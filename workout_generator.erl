-module(workout_generator).

-export([generate_workout/0]).

%% Generates a workout
generate_workout() ->
    EveryDayWorkouts = get_everyday_workouts(),
    SomeDayWorkouts = pick_someday_workouts(),
    print_workout({EveryDayWorkouts, SomeDayWorkouts}).

get_everyday_workouts() ->
    Cardio = pick_cardio_workout(),
    Yoga = get_yoga_workout(),
    Bujinkan = get_bujinkan_workout(),
    {Cardio, Bujinkan, Yoga}.

%% pick random choice of random workouts
%% We'll insert some random chances for "nothing" workouts so we don't overload
%% Later on we can adjust to make this adjustable
pick_someday_workouts() ->
    MiscWorkouts = [ukemi, weapon, animal, akban, with_weight,
                    short_machine_set, tsubatta, gardening, cleaning],
    NothingChances = lists:seq(1, trunc(length(MiscWorkouts) * 0.5)),
    PotentialWorkouts = MiscWorkouts ++ [nothing || _ <- NothingChances],
    RandomWorkoutIndex = rand:uniform(length(PotentialWorkouts)),

    case lists:nth(RandomWorkoutIndex, PotentialWorkouts) of
        ukemi -> {ukemi, []};
        weapon -> {weapon, []};
        animal -> {animal, []};
        akban -> {akban, []};
        with_weight -> {with_weight, []};
        short_machine_set -> {short_machine_set, []};
        tsubatta -> {tsubatta, []};
        gardening -> {gardening, []};
        cleaning -> {cleaning, []};
        _ -> {nothing, []} % nothing choice
    end.

%% I want to print out in a certain way to begin with.
%% Cardio -> Morning
%% Bujinkan + occassional -> Midday
%% Yoga -> Evening
print_workout(Workout) ->
    {{Cardio, Bujinkan, Yoga}, SomeDayWorkouts} = Workout,

    print_cardio(Cardio, morning),
    print_bujinkan(Bujinkan, midday),
    case SomeDayWorkouts of
        nothing -> ok;
        _ -> print_someday(SomeDayWorkouts, midday)
    end,
    print_yoga(Yoga, evening).

pick_cardio_workout() ->
    Workouts = [{run, {min, 30}},
                {run, {min, 60}},
                {bike, {hills, {min, 30}}},
                {bike, {hills, {min, 30}}}],
    lists:nth(rand:uniform(length(Workouts)), Workouts).

print_cardio(Cardio, TimeOfDay) ->
    io:format("Do ~w at ~w~n", [Cardio, TimeOfDay]).

print_bujinkan(Bujinkan, TimeOfDay) ->
    io:format("Do ~w at ~w~n", [Bujinkan, TimeOfDay]).

print_yoga(Yoga, TimeOfDay) ->
    {yoga, Week} = Yoga,
    io:format("Do ~s of Light on Yoga in ~s~n", [Week, TimeOfDay]).

print_someday(SomeDayWorkout, TimeOfDay) ->
    case SomeDayWorkout of
        {nothing, _} -> ok;
        {_, _} -> io:format("Do ~w at ~w~n", [SomeDayWorkout, TimeOfDay])
    end.

get_yoga_workout() ->
    {yoga, "Week1"}.

get_bujinkan_workout() ->
    {bujinkan, kihon_happo}.
