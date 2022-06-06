pragma solidity ^0.8.0;
import {IERC721} from "openzeppelin/token/ERC721/IERC721.sol";

interface IStarNFT is IERC721 {
    struct Lien {
        //        address broker;
        //        uint256 index;
        uint256 lienId;
        uint256 amount;
        uint256 rate;
        uint256 start;
        uint256 duration;
        uint256 schedule;
        uint256 buyoutRate;
        //        uint256 resolution; //if 0, unresolved lien, set to resolved 1
        //        address resolver; //IResolver contract, interface for sending to beacon proxy
        //        interfaceID: bytes4; support for many token types, 777 1155 etc, imagine fractional art being a currency for loans ??
        //interfaceId: btyes4; could just be emitted when lien is created, what the interface needed to call this this vs storage
    }
    enum LienAction {
        ENCUMBER,
        UN_ENCUMBER,
        SWAP_VAULT,
        UPDATE_LIEN,
        PAY_LIEN
    }

    struct LienActionEncumber {
        uint256 collateralVault;
        uint256 amount;
        uint256 rate;
        uint256 duration;
        uint256 position;
        uint256 schedule;
        address broker;
        uint256 buyoutRate;
    }
    struct LienActionUnEncumber {
        uint256 collateralVault;
        uint256 position;
    }

    struct LienActionSwap {
        uint256 collateralVault;
        LienActionUnEncumber outgoing;
        LienActionEncumber incoming;
    }
    struct LienActionPayment {
        uint256 collateralVault;
        uint256 position;
        uint256 amount;
    }

    function getTotalLiens(uint256) external returns (uint256);

    function getInterest(uint256 collateralVault, uint256 position)
        external
        view
        returns (uint256);

    function getLien(uint256 _starId, uint256 _position)
        external
        view
        returns (Lien memory);

    function getLiens(uint256 _starId) external view returns (Lien[] memory);

    function manageLien(LienAction _action, bytes calldata _lienData) external;

    function auctionVault(
        uint256 tokenId,
        uint256 reservePrice,
        address initiator,
        uint256 initiatorFee
    ) external;

    function getUnderlyingFromStar(uint256 starId_)
        external
        view
        returns (address, uint256);
}
