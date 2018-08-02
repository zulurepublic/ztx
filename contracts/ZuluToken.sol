pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";


/**
 * @title Zulu Token contract - ERC20 compatible token contract.
 * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
 */
contract ZuluToken is MintableToken {
    string public constant name = "Zulu Republic Token";
    string public constant symbol = "ZTX";
    uint8 public constant decimals = 18;
}
