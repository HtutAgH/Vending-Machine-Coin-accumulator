# Vending Machine Coins Accumulator

A small x86 32-bit assembly program that simulates a vending machine coin counter.

## How it works
 Keeps an internal counter (starting at 0).
  User enters a coin type:
  - `q` / `Q` → add 25 (quarter)
  - `d` / `D` → add 10 (dime)
  - `n` / `N` → add 5 (nickel)
  - Anything else, the program stops and prints the final total.
  The total is converted from an integer to ASCII using an `itoa` routine.
  Output is shown as `<amount> cents` without leading spaces.

## Example
./vending\n
Enter a coin (q/Q for quarter, d/D for dime, n/N for nickel): Q
change:25 cents
Enter a coin (q/Q for quarter, d/D for dime, n/N for nickel): d
change:35 cents
Enter a coin (q/Q for quarter, d/D for dime, n/N for nickel): x
end change:35 cents
