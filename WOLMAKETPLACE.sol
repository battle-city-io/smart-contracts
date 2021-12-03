pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WolMarketPlace {
    event List(
        bytes32 indexed offeringId,
        address indexed hostContract,
        address indexed offerer,
        uint256 tokenId,
        uint256 price,
        string uri
    );
    event Buy(bytes32 indexed offeringId, address indexed buyer);
    event OperatorChanged(address previousOperator, address newOperator);
    event OfferingClosed(bytes32 _offeringId);

    address operator;
    address wolTokenContractAddress;
    uint256 offeringNonce;
    IERC20 public WOLTOKEN;

    struct offering {
        address offerer;
        address hostContract;
        uint256 tokenId;
        uint256 price;
        uint256 marketFee;
        bool closed;
    }

    mapping(bytes32 => offering) offeringRegistry;

    constructor(address _operator, address _wolTokenContractAddress) {
        operator = _operator;
        wolTokenContractAddress = _wolTokenContractAddress;
        WOLTOKEN = IERC20(_wolTokenContractAddress);
    }

    function list(
        address _offerer,
        address _hostContract,
        uint256 _tokenId,
        uint256 _price,
        uint256 _marketFee
    ) external {
        require(
            msg.sender == operator,
            "Only operator dApp can create offerings"
        );
        bytes32 offeringId = keccak256(
            abi.encodePacked(offeringNonce, _hostContract, _tokenId)
        );
        offeringRegistry[offeringId].offerer = _offerer;
        offeringRegistry[offeringId].hostContract = _hostContract;
        offeringRegistry[offeringId].tokenId = _tokenId;
        offeringRegistry[offeringId].price = _price;
        offeringRegistry[offeringId].marketFee = _marketFee;
        offeringNonce += 1;
        ERC721 hostContract = ERC721(offeringRegistry[offeringId].hostContract);
        string memory uri = hostContract.tokenURI(_tokenId);
        emit List(offeringId, _hostContract, _offerer, _tokenId, _price, uri);
    }

    function buy(address _buyer, bytes32 _offeringId) external payable {
        require(
            msg.sender == operator,
            "only the operator can change the current operator"
        );
        uint256 buyerBalance = WOLTOKEN.balanceOf(_buyer);
        uint256 allowanceBalance = WOLTOKEN.allowance(_buyer, address(this));
        require(
            allowanceBalance >= offeringRegistry[_offeringId].price,
            "Allowance exceed limit"
        );
        require(
            buyerBalance >= offeringRegistry[_offeringId].price,
            "Not enough funds to buy"
        );
        require(
            offeringRegistry[_offeringId].closed != true,
            "Offering is closed"
        );
        ERC721 hostContract = ERC721(
            offeringRegistry[_offeringId].hostContract
        );
        hostContract.safeTransferFrom(
            offeringRegistry[_offeringId].offerer,
            _buyer,
            offeringRegistry[_offeringId].tokenId
        );
        WOLTOKEN.transferFrom(
            _buyer,
            offeringRegistry[_offeringId].offerer,
            offeringRegistry[_offeringId].price -
                offeringRegistry[_offeringId].marketFee
        );
        WOLTOKEN.transferFrom(
            _buyer,
            operator,
            offeringRegistry[_offeringId].marketFee
        );
        offeringRegistry[_offeringId].closed = true;
        emit Buy(_offeringId, _buyer);
    }

    function closeOffer(bytes32 _offeringId) external {
        offeringRegistry[_offeringId].closed = true;
        emit OfferingClosed(_offeringId);
    }

    function closeOfferList(bytes32[] _offeringIds) external {
        require(
            msg.sender == operator,
            "only the operator can change the current operator"
        );
        for (uint256 i = 0; i < _offeringIds.length; i++) {
            closeOffer(_offeringIds[i]);
        }
    }

    function changeOperator(address _newOperator) external {
        require(
            msg.sender == operator,
            "only the operator can change the current operator"
        );
        address previousOperator = operator;
        operator = _newOperator;
        emit OperatorChanged(previousOperator, operator);
    }
}
