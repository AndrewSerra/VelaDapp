// SPDX-License-Identifier: GPL-3.0 License
pragma solidity >=0.5.0;

/*
 * @title Time processes manager and helper functions
 * @author Vela
 */
contract TimeWiz {

    /*
     * @param _targetTime - The time that is checked if it is expired
     */
    modifier targetTimeInFuture(uint _targetTime) {
        require(_targetTime > block.timestamp);
        _;
    }

    
}