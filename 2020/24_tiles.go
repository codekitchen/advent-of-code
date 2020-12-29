package main

import (
	"fmt"
	"strings"
)

type coord struct {
	row, col int
}

var dirs []string

func init() {
	dirs = []string{"e", "w", "se", "ne", "sw", "nw"}
}

func Abs(v int) int {
	if v < 0 {
		return -v
	}
	return v
}

func (c coord) move(dir string) coord {
	var dr, dc int
	switch dir {
	case "e":
		dc = 1
	case "w":
		dc = -1
	case "se":
		dr = 1
		dc = Abs(c.row % 2)
	case "ne":
		dr = -1
		dc = Abs(c.row % 2)
	case "sw":
		dr = 1
		dc = -1 + Abs(c.row%2)
	case "nw":
		dr = -1
		dc = -1 + Abs(c.row%2)
	}
	return coord{c.row + dr, c.col + dc}
}

func parse(moves string) (c coord) {
	for idx := 0; idx < len(moves); {
		switch moves[idx : idx+1] {
		case "e", "w":
			c = c.move(moves[idx : idx+1])
			idx++
		default:
			c = c.move(moves[idx : idx+2])
			idx += 2
		}
	}
	return
}

// Grid is grid
type Grid struct {
	grid map[coord]bool
}

func (grid *Grid) flip(c coord) {
	if _, ok := grid.grid[c]; ok {
		delete(grid.grid, c)
	} else {
		grid.grid[c] = true
	}
}

func (grid *Grid) update() (updates []coord) {
	clearToCheck := make(map[coord]bool)

	partition := func(c coord) (set, clear []coord) {
		for _, dir := range dirs {
			neighbor := c.move(dir)
			if _, ok := grid.grid[neighbor]; ok {
				set = append(set, neighbor)
			} else {
				clear = append(clear, neighbor)
			}
		}
		return
	}

	for tile := range grid.grid {
		setNeighbors, clearNeighbors := partition(tile)
		for _, c := range clearNeighbors {
			clearToCheck[c] = true
		}
		if len(setNeighbors) < 1 || len(setNeighbors) > 2 {
			updates = append(updates, tile)
		}
	}
	for tile := range clearToCheck {
		setNeighbors, _ := partition(tile)
		if len(setNeighbors) == 2 {
			updates = append(updates, tile)
		}
	}
	return
}

func main() {
	var input = full
	grid := Grid{make(map[coord]bool)}
	for _, flipstr := range strings.Split(input, "\n") {
		grid.flip(parse(flipstr))
	}
	fmt.Printf("Initial: %d\n", len(grid.grid))
	for day := 1; day <= 100; day++ {
		for _, update := range grid.update() {
			grid.flip(update)
		}
		fmt.Printf("Day %d: %d\n", day, len(grid.grid))
	}
}

const small = `sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew`

const full = `wenwwsenwwwwnwwnwwwnwsewseewe
nenenwnenenenwnwnenenwneneseseswnenwwne
newewwwwwwswwwww
esenwwwswwnwnwswnwnwnwewnwsenwswwnwe
esesewseeneswnenwneeewnwneswsenwnee
neseswwswwseseseseseseswnwesesesesesese
sewwswsweswwwswswnwenwswswenesww
wenenesenenewnenenenwenweneneenewse
swswsenwneeseswnwswseseswswswneswsesesesw
wswswswsweswseswnwswswnwswswnwseswswswsee
nesweeeneeenwneswneswewneneenw
swseswswswswswswswswswnwswswswsw
eneneenwneeeeeeneeeese
newenwsenewnesenesenwnenenesenwnwnwne
nwswnenwswneneswenenwneswseeeneneneneee
nenenenwsesenwnwwnwnwsesenwseneswnenenw
eeeseseseeeeeewnwsweseneesesene
wesenwswwwwnewwnwenwnwswwswnww
esenweeeeneeswewenwneweseeee
swswnenenenenenenwneneswneswneneneenwe
neswseenwesenwneswnesewneswnewenwne
nwweswseseswewneeenweeseneeesese
wnwnwwnwnwswswnwswwneeewnwnwsenwnwnw
nenesenewnwneeenene
eseeeewneeeseswnwnwwwseswnewese
neswnenwnwneswenwenwswsewnwneenwwnw
sewswnwswsweswswwwweswwswneswwsw
seseseneseseswseswsese
eswswwnwewwnwswnwswneneseswe
nwswnwswsenwsesweseseseseswseseswswswsww
neneenwswnwwesesenese
wswswswwwwnwswswswweseswneswswwsw
eesewswsweseswsesweseswswswwswnwsww
neswnenwswnesenwnwswwenwswnenwenwnwnwne
swswneseneswwneswswswswwwwswnwnesesee
nwnwnenwneneesenwnwwseswwnwnenwnwnwnenw
esewseseseeswswsweesewnwwsesenwsew
nwsewswnwnwnwenwnwnwwnenwswnwnwnwnwnw
senewswnwnwwnwnwnweneseseneneswnwneesw
swseswnwseswnwseswneswseswswswse
nesenwnwnwnesewwseenenwswnesesenenewe
eseseweeseseneseeseeseeewnwse
wsewwneswneneswwswsewswwenwsewsww
ewswwwwwnwwsewnewwwwwwwe
swwweewwwwwewwewwwwswww
nwnenwwnenwnenenwnenwnwnwneswnenwnesenese
eseseseeseweseeeeenweseswseewse
nwswseswswswnesweswnwnwseswsw
seseseseseseseseneseseswesesese
swneswwnesenwwweswsewswsw
nwneneneenwnenenewnwnenene
swnwenwswwswwwswnwsweswswwswwsee
nwnwnwwnwnwnwnwswnwnwnwesenwnwsenwsenwne
nwneneesenweswswswwewswsewwswswse
senwneeneesweneeeewnweeswsenenew
newnwwnewswwwswneswewewsesenww
swnwnwnwnwnewswnwnesenweneweseeswnw
eswwwnwseswwwnewenewwwswwww
nwnwnwwnwneneneswsewneesenwneswnwewenw
neswswswwswswwswswswwseswwswwenwsw
wwwwwwsewnwwnwsenewwnw
nwneswswnweswnweswswswwsewneseswsesesw
wnwsweneswsenwnenwseswwnenewnwneseswse
newewneswswswnwwswwswseswswwswsesw
neneneswnenwnenwneeseseewsweneswnwnw
nwnewneneenwseeswesenewneneneswenwnw
nenwnenwnenenwnenenwwnwsenwsenwnesewnee
nwnenenewenenenwnenenenenesenwswnenwnese
nesewswwwwsenwnenwwnwwsenewwww
enwnwnwnwnwwnwnwnwnw
swseseneseneswenewsewwsewnesesesenwswse
sweneneeneeswneeeeeneenee
sesenenwsesenwseseseseseesenwswswswsene
seswseewswsesweswseswewswnw
swneenwneeeeeenewneeswneneneene
eeeweneneeeneeeneswnesenewwnenw
swnwseenwnenwnwnwnwnenenwnwwnenwnwnwnw
wnwnwneswenwnwenwnwswnwwnwnwnwnwswnw
swswswswnwseseeneseseseseseseswnwseswse
neeweneswesweeeeseenenweeseeenw
wnwnwnwneenwswnwnwnwenenweswnwwnwnwnw
senwwswnwsenewewenenwewsenwwseesw
ewswwswnwwwwnewwwenw
enenwnenwnenwnwsenewnwneeswnenenenenwnw
seseeseeseswsewnwwseseseseeseeeneese
nwneseswnwsenesewnwnewsesweswsw
nwswsweeswswnwswwenwwswnweswswnwswse
neewseeseseeseeseseseenwee
senwnwwwnwewnwwnwnwnwnwnwnwnw
eeewneenwesenwseseweeeeseee
swnesenwsewseseswnwswwnwnesw
wnwwwnwnwnwnwswnwnweenwnwnwwwenwswnw
nwnwsenwnwnesenwnwnwnwnenwnwnenwswwnwnw
nwewswswwwsewwewnwnenwenwnwnwnwwnw
wnesweneseswnwnesesewseswseswwswse
enesewneenenweseswnesenwesewwneene
eneenwnenenenewswsese
wsewnewswnwseneswswwswnwwweswsesw
eeswneeseeeeeeneeeenwnwwenee
eswsenweeeseeseewnwneeseeseeenw
sesewseswewseeseneeseseneesenwsesese
wswnewnwnwswnenwnwswenwnwsenewswenw
newnesenwnwwnwnwwsenenwnwnwsenenwnwnwe
esweweswsenwnenwnweneeeseeeee
nenwseneneneneneeneseenenenwnenene
esesenwnwswesewneseseesenwseseseese
swswwsweswswnesweswneswwsewswswse
enesweeeenewneswswenenenenwnenene
enwswswnwsewnenwnweneeeeeeeese
enwnweneswswnenenwnesweswnwse
seswseseewneweenweesenewseesesw
swswnenwnwwswswseenenwwneneeeneneneswne
sewwnwnwwwwsewwnwnwwnwewewnww
neseseseswneseeswseseseseseswswwswswse
seseswswswseswwseswsesesesesesene
swenweeneeenwneeeeeese
eneseswswswswewwseseswswnwwswnwneswnenw
wswseeeeneswneneenenenwenweeene
wwwwwnewwwnwsewnwww
nwnwswnwnwnwnwwswsenwnwnenwwewnenw
nwswwswnwwnwnwwewwneenwnwnwnwwwwse
nwnenewseswnwnwsenenenenwnenenenenenee
nwswsenwwsewsenenwnenwnwse
nenwnwnenesenwnwnwnwnenww
ewswnwswswswweswwwseswwswwnenwsw
neseswswneswseswswneswswswswwsweswsenwswsw
newnenwneseeneneswnenenenwnenwenwswnesw
swswswseseseseswswswseswne
nwswswswwwwneseeswsewwswswswswseswnew
swnwsewwwsewnwww
swswseseeswswnenwwswswswswneswwseswswswnw
enenwswneeeneneneneeweneneeseenenw
neswneswwnwenwnwnwswswneeseneewenw
neeenewswneeseeeeneeeeneeenesw
swsesewsesweesewnwnenwnwseswse
swswneswsewnewwwneneesww
nenwnesenesesenwnwnenwnenewnenwnewnenwne
wwsenwsenwenwnwnwwwnwswenwsewnew
neseseenwswswwenwneeeneswenwswweswnw
swswneneneseneseswnwnenwnwneenenwneewne
wnwswwwwweewwswwwsw
wneeneswswseswnwswswswsewswswnwswnesesw
nwenwwnwnwsewnwnwnesesenwnwswnwwneww
enenwseeesewweeswnewsesweesee
wwnewwwwwswww
swneseswswwneneeneswsewnenenwswewnese
nwnewnwnwsenwnwnwwwseeseseewswewnw
eeeweeeesenenene
nwnwwnwenwswnwnwenwnwnwnwsenenwswnwnwnw
wnwneewseenwnwnwwnwwweeswwswnw
sesesesenwsesesesesenwnwse
esweenewsweeneneenenewneeeee
swnweeeneeewsweeneeeseeeeseee
newsweswswnwwewnwwswneswsw
senwnwwnenenenenwnene
nenwneneneenenewseeeneneenewnewne
neswnwswsewwnwenenwwwwnwwsewsww
swnwsesesesesenweeeseseswwseneseeesese
nwnwnwnwnwwnwwnwnwwwwnwe
swswwneswswneswswswswswswseseswnenwswe
enenenenwseseseenwnenenwswnenwnenesenene
eneseeneeenwnwneseenwsewnwesenee
sewswswwswwswneewnwswwnwwswnwswsesenw
seseseseseseseseseneswsewe
swwswswswewswswswswswsw
eeeeneenweswseswee
nwsesesewseswseneeseseseseswsesenesesenw
swneneswswswsenenwenwswswseswneeseswswnw
nwwnwnewwswswwwwneseswwswnwswwsese
esenwneenweeneswswweneeeswseee
eeeeeeeeeneswesewseeneewsee
neswwwswwwnweswswwewwnw
nenenwnenenwseneneswnwewnwwneswnw
swseswwswswweneswwswnwwwsewenwne
swseesewswseseseeswsenw
nesewswewnewwnwwsenwnwwswwswsenw
eseneeseesenwswsesesewseeseseseneswe
weseswwnwseseseseesesenwenesesenwsese
ewsesenwneseneswswewswswwnwswnesesw
swswswswseswswswsenesesewsenw
nwnwnenesenenenwnwnwsenwnwnwnenwnwwsesw
enewswnenwnwnenwnenenweewenenwsw
neeswnenenwnenenwneenenwswnenenenenwne
nenenwneswnenwnwnwswenwnwnenenwnwnwswswe
wnwwwnenwnwwnenwwwswwwwnwwsewse
neeeneneneneesenenenenenwnenewwnese
nwenwesenwwnwnwnwnwnwnwnwswnwnwsenenenw
ewwwswwweswewswswswwwwewnww
swwsenwwwsenwwwswnwesenwwswenesww
eweswswswnwnwswwnwswneeseeseswwsww
nwnwnwenenwnwnwnwnwewnwnwnww
wneenwenewesesesee
nwswswswwsweseswnwswswwswswneenwswswe
eseseseseswseseswsenwseswneseseswnw
swseswswseswsweweswswswnwswswseswswswnw
swewswswswseseseseswswswswsesenwseeswnw
nenwnwnenwneneseswnwneswseneneswsw
swnweseswnwneseseenewsese
eweneswsenesewsesenweswseeenwew
wweswsenwnwswwswneneneswwswsewsesene
seeeseeseseseweseseseeswnwe
nwnwnwnesenwenwnwsenwwnwnwnwnwwnwwnw
sesewseeeeseseneeseseweesesesenwe
wnewswswnewswswswswswnwswsweswswww
neweeeeeeneneenweesesesw
enesenewsenwnewwwwnwwnwsenwwwswse
senwseesweseeenweenesweneseeesee
sesweseswseswwneswwswswsweswsenwswswsw
swneneeneswneneneneeenwewneseeew
sweswwnewswsweswswnwwwswswswwwwsew
nwseseseswneesesewseseseseseseesesese
seseswswnwnwwseeseswneseesesesesesewne
neseseswseseseswseneswseswseswwnwswsesesw
nwswwwwwnwwnwweswnwwwsewwnwnewe
eeeneeenewswnene
seseseseswnwesenwseseseesweesesesee
nwswwnewneseswwseneneseswnewwwswwsesw
eeenweeeeeesenenweewsweese
enwswnwswneneswnwnwnwnwnwnenweneneseswnw
senenwwneswseswwswneneneneswsewswnenene
nwnwwsesenewnwswsesewsesewseseeenee
swneseseeeweeesenesewewnwseseesesw
neeenwweeenesewnwwewseesesese
neneswswnenenenenenenenenenenenewneese
swenenenwnwnwseesesenwswsenwsewesweww
wenewswwwnwesewswwwenwnenww
neneneseeneneneneneswneenenwnewwnenene
sewwnwsenenwwwsewwwwne
sewsesenwseseseeeeeseewwesenwnee
seswnwnenwneseeseswnenewwesewnenenw
seeseswseseenenwenwneenewsweenww
wnwnwwwnwswwwwwsewnenw
seswswneswswswwswswneneswswswsw
swnwsewnwsewnwwnwnenwwnwnwnw
nwsewswswnwwswswswsweeswesesesenesw
swswnwseseswswswnwseswseswseseweswsenesese
wnwnwwnwswswneeweswseewwnweswswse
nwwwewnwwnenwnwsewnwwnewnwnwsww
seeswseswseswseswsesesenewswswsenww
swnenwswwneneenenesenwneeeneeenee
weseswsesesewsesesenwseneseseseseese
swneeneesewwseswswenwneeswseenwnw
wnwwnwwwwwnwwwwnwe
newwenwseswnewnwsesweneneesenwsew
seenewneneswnwnenewnenwneneeewsenwsw
nwewnwsenwnwwnwnew
neneneneswnenenwnenenenenenene
newsenewneeewnwwwwswseswwwnee
wswneswewnwswnwwswesewwneswswswww
wseeeneseneesesweeeswnweeseneee
seeswswswwsewswswseeswnesewswsweswse
sesenwnwnwwwswwnwnwswenwewsenwwnew
weseneeeeeeeeee
swwswseeswswsesenwnwseswswseesenwesw
eneneweeneeneeeneene
newwswwnewwwswnewsewwwswwwwse
wsenwnwnwnwenwenwnewsw
wwnwnwwwnwwewwnwnwneenwnweswww
eseeeeeneneeesewswenweewnenene
nenwneneswneneswnenwneneswnenwnenenwene
sesesesesewnewnesenwseseswsesesesesesesese
swneneswneseswneneneeswneeenwnewenwne
nwsenwnwsenwwnwnwsewnwnwsenwnwnwnwnwnenw
wnenwnwwswenwenwwnwwnwseswnwswnwwnw
nwnwnwwsewswnewnwwesenesenwnwnwnwnw
swswenesenwneenwwsenwnwnwnenwnwnwsew
nenenwswnenenwnenenwsenwnesenwnewnwwnenene
swwnewwswwwwwnewwww
eeeswswneneeeneneeeeswnenee
swseseswnesewseseswswseenwswseeswswse
wewwewwswwswwwwwnwswenwnwesww
nwnwwnwnenwsewswwwnewwnwwnwsenwww
eeneneswneesenesweneneenenewneenenw
enenwnwswnwnwseneswswnweeswnwnwsenwnwnwnw
neneneneneswneneneneneneeswnenesenwnenwnw
enweseeeseswseenweeswseeesesee
nwswseseswneswsewseseswneseswseseseew
swsenesewswswswnwwwnwwswswwswwwse
sweswnwswwsewseseseswswseswnwneswsw
neeweneesenenwnwswseeeeeenenewe
wnwnwwwnwweenwswwwww
neseswseeeseeewsenweneseese
neswswswswswswseseswswswswnwsweswswnwswsww
nwwnwewwwwwswwwwswnwnwwnwew
nwnwnenwnwnwnwenwneenwnenwnwnwsewnenwsw
nwnenwnenwnwwnwsenwnwwnwwwwnwsesenwnw
swswswseswsesewsewnenwseswswswseswswsenesw
seweweswswseswwnwseswseseenwenew
eenweeeeeeseesenw
wsewwwwsewnewwwesenwneseswneenew
seweseeeeeeeeeee
swsenwswneswswswsesesesewseseneswseswsew
swswneneneneenenenenenweneneneneneswnwene
seeseeneneswwswsenwenwseseneseswswnw
nenesesewnwnenwnwsenwnenenwnenenwnwnwwse
wswnwwneswnweseseswwe
wswsenwswswswweswnwswswwswswsweswnwe
swsesesenwsesenewsesenwseseswsesesenesese
nwnwwnweswnwsenwnwnwsewswnenwnwneese
swswseswwnwsesewesewneswneneseswnwnw
swsweseswsesenwwsenwseseswswseenwsesw
eeneeswenweeneesweeneeenwene
nwswwwwwneswswswseeneswwswseswswnwsw
nwswneseneswswneswneseseswswnesenw
nwnwwneneswneesweenenenewnwnenenwnw
nwwnwenwnwenwwnwnwnwnwnwnwwww
eeesweeeweeneeeenweeweseee
nwenwnwnwnwnwenwnwwnwewnwnwwnwswnwnw
nwneneenewenewseneswneneneneenwwneswne
wwnwwnesesewwwwnewwsewwnwww
swswswnwswseswswwswsweswneswseswswswe
sewwneseseswneseseseneswseswseseew
nwneneenenesweneneneenenenenweesw
sesesenwneewseseeenwnwneenwwswnwswsw
weseneseeneneneweeswewnesesewsw`
