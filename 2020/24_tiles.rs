#!/usr/bin/env rust-script
// cargo-deps: regex, lazy_static
#![allow(dead_code)]

use std::collections::HashSet;
use std::ops;
use regex::Regex;
#[macro_use] extern crate lazy_static;

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, Default)]
struct Coord {
    row: i32,
    col: i32,
}

impl Coord {
    const ZERO: Coord = Coord { row: 0, col: 0 };
    fn neighbors(self) -> [Self; 6] {
        [ self + E, self + W, self + SE, self + NE, self + SW, self + NW, ]
    }
}

#[derive(Debug, Default)]
struct Grid {
    grid: HashSet<Coord>,
}

enum Dir {
    E, W, NE, NW, SE, SW,
}
use Dir::*;

impl ops::Add<Dir> for Coord {
    type Output = Coord;
    fn add(self, dir: Dir) -> Coord {
        let even_row = self.row % 2 == 0;
        let (dr, dc) = match dir {
            E => (0,1),
            W => (0,-1),
            SE => (1, if even_row { 0 } else { 1 }),
            NE => (-1, if even_row { 0 } else { 1 }),
            SW => (1, if even_row { -1 } else { 0 }),
            NW => (-1, if even_row { -1 } else { 0 }),
        };
        Coord { row: self.row + dr, col: self.col + dc }
    }
}

fn split<'a>(id: &'a str) -> impl Iterator<Item=Dir> + 'a {
    // needs nightly feature:
    // id.split_inclusive(&['e', 'w'] as &[_])
    lazy_static! {
        static ref RE: Regex = Regex::new(r"ne|nw|se|sw|e|w").unwrap();
    }
    RE.captures_iter(id).map(move |cap| {
        match &cap[0] {
            "e" => E, "w" => W, "ne" => NE, "nw" => NW, "se" => SE, "sw" => SW,
            _ => panic!("bad input {}", id),
        }
    })
}

impl Grid {
    fn parse(id: &str) -> Coord {
        split(id).fold(Coord::ZERO, |c, dir| c + dir)
    }

    fn flip<I: IntoIterator<Item=Coord>>(&mut self, cs: I) {
        for c in cs {
            if !self.grid.insert(c) {
                self.grid.remove(&c);
            }
        }
    }

    fn count(&self) -> usize {
        return self.grid.len()
    }

    fn update(&self) -> Vec<Coord> {
        let mut clear_to_check = HashSet::new();
        let mut flips = vec![];

        let partitioned_neighbors = |tile: Coord| -> (Vec<Coord>, Vec<Coord>) {
            tile.neighbors().iter().partition(|n| self.grid.contains(n))
        };

        for tile in &self.grid {
            let (set_neighbors, clear_neighbors) = partitioned_neighbors(*tile);
            clear_to_check.extend(clear_neighbors);
            if set_neighbors.len() < 1 || set_neighbors.len() > 2 {
                flips.push(*tile)
            }
        }
        for tile in clear_to_check {
            let (set_neighbors, _) = partitioned_neighbors(tile);
            if set_neighbors.len() == 2 {
                flips.push(tile)
            }
        }
        flips
    }
}

fn main() {
    let input = FULL;
    let mut grid = Grid::default();
    assert_eq!(Coord { row: 1, col: 0 }, Grid::parse("esew"));
    assert_eq!(Coord { row: 0, col: 0 }, Grid::parse("nwwswee"));
    assert_eq!(Coord { row: -1, col: 0 }, Grid::parse("ne"));
    assert_eq!(Coord { row: -1, col: -1 }, Grid::parse("new"));
    assert_eq!(Coord { row: -2, col: 2 }, Grid::parse("nenee"));
    let initial_flips = input.split('\n').map(Grid::parse);
    grid.flip(initial_flips);
    eprintln!("Initial: {}", grid.count());
    for day in 1..=100 {
        grid.flip(grid.update());
        eprintln!("Day {}: {}", day, grid.count());
    }
}

const SMALL: &str = "sesenwnenenewseeswwswswwnenewsewsw
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
wseweeenwnesenwwwswnew";

const FULL: &str = "wenwwsenwwwwnwwnwwwnwsewseewe
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
weseneseeneneneweeswewnesesewsw";
