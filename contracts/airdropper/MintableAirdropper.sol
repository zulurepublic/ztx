pragma solidity 0.4.24;

import "./AirDropperCore.sol";


/**
 * @title MintableAirDropper
 * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
 * @dev Airdrop contract that mints ZTX tokens
 */
contract MintableAirDropper is AirDropperCore {
    /**
     * @dev Constructor for the airdrop contract.
     * NOTE: airdrop must be the token owner in order to mint ZTX tokens
     * @param _airdropReceiversLimit Cap of airdrop receivers
     * @param _tokenAmountPerUser Number of tokens done per user
     * @param _ztx ZTX contract address
     */
    constructor
        (
            uint256 _airdropReceiversLimit,
            uint256 _tokenAmountPerUser,
            ZTXInterface _ztx
        )
        public
        AirDropperCore(_airdropReceiversLimit, _tokenAmountPerUser, _ztx)
    {}

    /**
     * @dev override sendTokensToUser logic
     * @param recipient Address to receive airdropped tokens
     * @param tokenAmount Number of rokens to receive
     */
    function sendTokensToUser(address recipient, uint256 tokenAmount) internal {
        ztx.mint(recipient, tokenAmount);
        super.sendTokensToUser(recipient, tokenAmount);
    }

    /**
     * @dev Self-destructs contract
     */
    function kill(address newZuluOwner) external onlyOwner {
        require(
            numOfCitizensWhoReceivedDrops >= airdropReceiversLimit,
            "only able to kill contract when numOfCitizensWhoReceivedDrops equals or is higher than airdropReceiversLimit"
        );

        ztx.unpause();
        ztx.transferOwnership(newZuluOwner);
        selfdestruct(owner);
    }
}
