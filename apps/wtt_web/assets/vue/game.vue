<template>
    <div class="container-fluid">
        <div class="row">
            <div class="col-1 text-center">
                <p v-if="player" class="text-success">Your hero's name is {{ player }}</p>
                <div class="d-flex justify-content-center">
                    <button type="button" class="m-2 btn btn-sm btn-primary" @click="move('up')">
                        Up
                    </button>
                </div>
                <div class="d-flex justify-content-center m-1">
                    <button type="button" class="m-1 btn btn-sm btn-primary" @click="move('left')">
                        Left
                    </button>
                    <button type="button" class="m-1 btn btn-sm btn-primary" @click="move('right')">
                        Right
                    </button>
                </div>
                <div class="d-flex justify-content-center">
                    <button type="button" class="m-2 btn  btn-sm btn-primary" @click="move('down')">
                        Down
                    </button>
                </div>
                <button type="button" class="btn btn-primary" @click="attack()">Attack</button>
            </div>
            <div class="col-11">
                <div v-for="row in boardSize" class="d-flex border-left border-top border-dark"
                     style="width: 100%; height: 60px"
                     :class="row === boardSize ? 'border-bottom' : ''">
                    <div v-for="col in boardSize"
                         class="border-right border-dark overflow-hidden" :style="tileStyle"
                         :class="tileClasses(col, boardSize - row + 1)">
                        <span v-if="myPlayer(col, boardSize - row + 1)" class="badge"
                          :class="playerClass(myPlayer(col, boardSize - row + 1))">
                            {{ player }}
                        </span>
                <span v-for="p in otherPlayers(col, boardSize - row + 1)" class="badge"
                      :class="playerClass(p)">
                    {{ p.name }}
                </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
const BOARD_SIZE = 10
const boardIndex = (x, y) => (y - 1) * BOARD_SIZE + x - 1
const INITIAL_BOARD = new Array(BOARD_SIZE * BOARD_SIZE).fill({
    players: [],
    wall: false
})


export default {
    data: () => ({
        boardSize: BOARD_SIZE,
        board: INITIAL_BOARD,
        tileStyle: {
            width: (100 / BOARD_SIZE) + '%'
        },
        player: null
    }),
    mounted() {
        this.initPlayer(this.$route.query.player || undefined)
        setInterval(this.updateBoard, 1000)
    },
    methods: {
        playerClass(player) {
            if (player.status === 'alive') {
                if (player.name === this.player) {
                    return 'badge-success'
                } else {
                    return 'badge-primary'
                }
            }
            return 'badge-danger'
        },
        tileClasses(x, y) {
            const tile = this.boardElem(x, y)
            return tile.wall ? 'bg-danger' : ''
        },
        myPlayer(x, y) {
            return this.boardElem(x, y).players
                .find(({name}) => name === this.player)
        },
        otherPlayers(x, y) {
            return this.boardElem(x, y).players
                .filter(({name}) => name !== this.player)
        },
        boardElem(x, y) {
            return this.board[boardIndex(x, y)]
        },
        players(x, y) {
            return Array.from(this.boardElem(x, y).players).sort((p1, p2) =>
                p1.name === this.player ? -1 : p1.name < p2.name
            )
        },
        async initPlayer(player = "") {
            const playerResponse = await this.axios.post(`/player/${player}`)
            this.player = playerResponse.data.player
            if (this.player !== player) {
                await this.$router.push({query: {player: this.player}})
            }
        },
        move(dir) {
            this.axios.put(`/player/${this.player}/move/${dir}`)
        },
        attack() {
            this.axios.put(`/player/${this.player}/attack`)
        },
        async updateBoard() {
            for (let i in this.board) {
                this.board[i] = {
                    players: [],
                    wall: false
                }
            }

            const response = await this.axios.get("/board")

            for (let board_el of response.data) {
                const {tile: [x, y]} = board_el
                this.$set(this.board, boardIndex(x, y), board_el)
            }
        }
    }
}
</script>