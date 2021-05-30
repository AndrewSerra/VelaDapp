// SPDX-License-Identifier: GPL-3.0 License
pragma solidity >=0.5.0;

/*
 * @title A store contract to manage coupon sales
 * @author Vela
 */
contract Store {
    string public name;
    string public description;
    address public owner;
    // Keeping track of posters
    uint private activeCount = 0;
    uint private posterCount = 0;
    mapping (uint => Poster) public posters;
    // constant time period for minimum operation window
    uint MIN_POSTER_TIME = 1 hours;
    // constant time period for minimum time between now and start time
    uint MIN_TIME_TO_START = 30 minutes;

    struct Poster {
        uint id;
        uint startTime;
        uint endTime;
        bool purchased;
        bool active;
        address payable owner;
    }

    /*
     * @descr Check whether the given id is valid
     * @param _posterId - Id of the target poster
     */
    modifier hasValidPosterId(uint _targetPosterId) {
        require(posterCount > _targetPosterId);
        _;
    }

    /*
     * @descr Check whether the contract owner matches poster owner
     * @param _posterId - Id of the target poster
     */
    modifier storeOwnsPoster(uint _targetPosterId) {
        require(posters[_targetPosterId].owner == owner);
        _;
    }

    /*
     * @descr The address of the request matches the owner
     */
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    /*
     * @descr Check whether the poster is active
     * @param _posterId - Id of the target poster
     */
    modifier posterIsActive(uint _targetPosterId) {
        require(posters[_targetPosterId].active);
        _;
    }

    /*
     * @descr Contructor of the Store, manage coupon sales
     * @param _name - Name of the store creating the contract
     */
    constructor(string memory _name, string memory _description) {
        name = _name;
        description = _description;
        owner = msg.sender;
    }

    function setPostersToDeactive(uint[] memory _posterIds) external isOwner {
        // require(activeCount <= _posterIds.length);
        
        for(uint i=0; i < _posterIds.length; i++) {
            if(_posterIds[i] < posterCount && posters[i].active) {
                posters[i].active = false;
                activeCount--;
            }
        }
    }

    function getActivePosterCount() external view returns (uint) {
        return activeCount;
    }

    function getActivePosters() external view returns (Poster[] memory) {
        Poster[] memory activePosters = new Poster[](activeCount);
        uint count = 0;

        for(uint i=0; i < posterCount; i++) {
            if(count == activeCount) {
                break;
            }

            if(posters[i].active) {
                activePosters[count] = posters[i];
                count++;
            }
        }
        return activePosters;
    }

    function createPosters(uint _startTime, uint _endTime, bool _active, uint _amountAvailable) public isOwner {
        for(uint i=0; i < _amountAvailable; i++) {
            uint newId = posterCount + i;
            posters[newId] = _createNewPoster(newId, _startTime, _endTime, _active);

            if(_active) {
                activeCount++;
            }
        }
        posterCount += _amountAvailable;
    }

    function _createNewPoster(uint _id, uint _startTime, uint _endTime, bool _active) private view returns (Poster memory) {
        require((_endTime - _startTime) >= MIN_POSTER_TIME);
        require((block.timestamp + MIN_TIME_TO_START) <= _startTime);

        return Poster(_id, _startTime, _endTime, false, _active, payable(msg.sender));
    }
}