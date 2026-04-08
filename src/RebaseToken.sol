// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Rebase Token
 * @author Aayush
 * @notice This is going to be a cross-chain rebase token that incentivises users to deposit into a valut and gain interest in reward
 * @notice The interest rate in this contract can only decrease
 * @notice Each user will have their own interest rate that is the global interest rate at the time of depositing.
 * 
 */
contract RebaseToken is ERC20 {
    error RebaseToken__InterestRateCanOnlyDecreas(uint256 oldInterestRate, uint256 newInterestRate);

    uint256 private s_interestRate = 5e10; //0.00000005 // rate per second
    mapping (address => uint256) private s_userInterestRate;
    mapping (address => uint256) private s_userLastUpdatedTimestamp;

    event InterestRateSet(uint256 newInterestRate);

    contructor() ERC20("Rebase Token" , "RBT"){}

    /**
     * @notice Set the interest rate in the contract
     * @param _newInterestRate The new interest rate to set
     * @dev The interest rate can only decrease 
     * 
     */
    function setInterestRate(uint256 _newInterestRate) external {
        //set the interest rate
        if(_newInterestRate > s_interestRate){
            revert RebaseToken__InterestRateCanOnlyDecreas(s_interestRate, _newInterestRate);
        }
        s_interestRate = _newInterestRate;
        emit InterestRateSet(_newInterestRate);
    }

    function mint(address _to, uint256 _amount) external {
        _mintAccuredInterest(_to);
        s_userInterestRate[_to] = s_interestRate;
        _mint(_to, _amount);
    }

    function balanceOf(address _user) public view override returns (uint256) {
        // get the current principal balance of the user + interest oken during last update (the number of tokens that have actually been minted to the user)
        // multiply the principle balance by the interest that has accumulated in the time since the balance was last updated
        return super.balanceOf(_user) * _calculateUserAccumulatedInterestSinceLastUpdate(_user);
    }

    function _mintAccuredInterest(address _user) internal {
        // (1) find their current balance of rebase tokens that have been minted to the user --> principal balance
        // (2) calculate their current balance including any interest --> balanceOf
        // calculate the number of tokens that need to be minted to the user --> (2) - (1)
        // call _mint to mint the tokens to the user
        // set the users last updated timestamp
        s_userLastUpdatedTimestamp[_user] = block.timestamp
    }

    /**
     * @notice Get the interest rate for the user
     * @param _user The user to get the interest rate for 
     * @return The interest rate for the user
     * 
     */
    function getUserInterestRate(address _user) external view returns (uint256) {
        return s_userInterestRate[_user];
    }

}