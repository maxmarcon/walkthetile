<template>
    <div class="container-fluid">
        <div v-for="row in boardSize" class="d-flex border-left border-top border-dark"
             style="width: 100%; height: 60px"
             :class="row === boardSize ? 'border-bottom' : ''">
            <div v-for="col in boardSize"
                 class="border-right border-dark" style="width: 10%"
                 :class="tileClasses(col, row)">
                <span v-for="player in boardElem(col, row).players" class="badge"
                      :class="player.status === 'alive' ? 'badge-primary' : 'badge-danger'">
                    {{ player.name }}
                </span>
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
        board: INITIAL_BOARD
    }),
    mounted() {
        // this.updateBoard()
        setInterval(this.updateBoard, 1000)
    },
    methods: {
        tileClasses(x, y) {
            const tile = this.boardElem(x, y)
            return tile.wall ? 'bg-danger' : ''
        },
        boardElem(x, y) {
            return this.board[boardIndex(x, y)]
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