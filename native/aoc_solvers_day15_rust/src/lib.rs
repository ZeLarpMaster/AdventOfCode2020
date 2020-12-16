use rustler::{Encoder, Env, Error, Term, NifResult, SchedulerFlags};
use rustler::types::list::ListIterator;

mod atoms {
    rustler::rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Aoc.Solvers.Day15.Rust",
    [
        ("start_speaking", 2, start_speaking, SchedulerFlags::DirtyCpu)
    ],
    None
}

/*
defp start_speaking_old(input, max_turn) do
    speak(0, Map.new(Enum.with_index(input, 1)), length(input) + 1, max_turn)
end

defp speak(number, _, turn, max_turn) when turn == max_turn, do: number

defp speak(number, spoken_map, turn, max_turn) do
    last_spoken = Map.get(spoken_map, number)
    spoken_map = Map.put(spoken_map, number, turn)

    if last_spoken == nil do
        0
    else
        turn - last_spoken
    end
    |> speak(spoken_map, turn + 1, max_turn)
end
*/

fn start_speaking<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input_iterator: ListIterator = args[0].decode()?;
    let input: Vec<usize> = input_iterator.map(|x| x.decode::<usize>()).collect::<NifResult<Vec<usize>>>()?;
    let max_turns: usize = args[1].decode()?;

    let mut spoken: Vec<usize> = vec![usize::MAX; max_turns];

    let mut number: usize = 0;
    for (i, value) in input.iter().enumerate() {
        spoken[*value] = i;
        number = *value;
    }

    spoken[number] = usize::MAX;

    for turn in input.len()..max_turns {
        let last_spoken_turn = spoken[number];
        spoken[number] = turn - 1;
        if last_spoken_turn == usize::MAX { // Number wasn't spoken before
            number = 0;
        } else {
            number = turn - 1 - last_spoken_turn;
        }
    }

    Ok((atoms::ok(), number).encode(env))
}
