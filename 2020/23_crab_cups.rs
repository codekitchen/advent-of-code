#!/usr/bin/env rust-script

fn link_each<'a>(cups: &'a[usize], start: usize) -> impl Iterator<Item=usize> + 'a {
    // std::iter::successors(Some(cups[start]), move |&cur| Some(cups[cur]))
    let mut cur = start;
    std::iter::repeat_with(move || { cur = cups[cur]; cur })
}

fn main() {
    // let init = [3, 8, 9, 1, 2, 5, 4, 6, 7]; // EXAMPLE
    let init = [4, 1, 8, 9, 7, 6, 2, 3, 5]; // REAL
    let pt2 = true;

    let ilen = init.len();

    let clen = if pt2 { 1_000_001 } else { ilen+1 };
    let mut cups = vec![0; clen];

    cups[init[ilen-1]] = init[0];
    for i in 1..ilen {
        cups[init[i-1]] = init[i];
    }
    if pt2 {
        cups[init[ilen-1]] = ilen+1;
        for i in ilen+1..1_000_000 { cups[i] = i+1 }
        cups[1_000_000] = init[0];
    }

    let min = 1;
    let max = clen - 1;
    let mut cur = init[0];

    let cycles = if pt2 { 10_000_000 } else { 100 };
    for _round in 1..=cycles {
        // eprintln!("\n-- move {} --", round);
        let pick = [cups[cur], cups[cups[cur]], cups[cups[cups[cur]]]];
        // let pick: Vec<usize> = link_each(&cups, cur).take(3).collect();
        // eprintln!("pick up: {:?}", pick);
        let dest = {
            let mut dest = cur;
            loop {
                dest -= 1;
                if dest < min { dest = max }
                if !pick.contains(&dest) { break dest }
            }
        };
        // eprintln!("destination: {}", dest);
        let prev = cups[dest];
        cups[dest] = pick[0];
        cups[cur] = cups[pick[pick.len()-1]];
        cups[pick[pick.len()-1]] = prev;
        cur = cups[cur];
    }

    eprint!("\nanswer: ");
    if pt2 {
        let a = cups[1];
        let b = cups[a];
        eprint!("{} * {} = {}", a, b, a*b);
    } else {
        for curp in link_each(&cups, 1).take(ilen-1) { eprint!("{}", curp) }
    }
    eprintln!("");
}
