# Cross-chain Rebase Token

1. A protocol that allows user to deposit into a valut and in returns, receive rebase tokens that represent their underlying balance.
2. Rebase token --> balanceOf function is dynamic to show the changing  balance with time.
    - balance increases linearly with time
    - mint tokens to our users every time they perform an action (minting, burning, transferring, .... bridging) --> instead of keep updating the balance with interest gains, we only update it when user is interacting with balance in some way.
3. Interest rate
    - Individually set an interest rate for each user based on some global interest rate of the protocol at the time user deposits into the vault.
    - This global interest rate can only decrease to incetivice/reward early adopters.
    - user's interest rate will be the global interest rate at the time of deposit and remains same for deposited amount.
    - This is going to increase token adoption
