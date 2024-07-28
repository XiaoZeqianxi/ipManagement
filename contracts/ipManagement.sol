// author @XiaoZeqianxi
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ipManage {

    struct copyright {
        int crNo;
        string crName;
        address[] crCreator;
        address[] crOwner;
        string crType;
        uint crRegisTime;
        bytes32 crUniqueNo;
    }

    struct patent {
        int ptNo;
        string ptName;
        address[] ptCreator;
        address[] ptOwner;
        string ptType;
        uint ptRegisTime;
        uint ptExpireTime;
        bytes32 ptUniqueNo;
    }

    struct trademark {
        int tmNo;
        string tmName;
        string tmRange;
        address[] tmDesigner;
        address[] tmOwner;
        uint tmRegisTime;
        uint tmExpireTime;
        bytes32 tmUniqueNo;
    }

    mapping (int => copyright) private crs;
    int crCount;

    mapping  (int => patent) private pts;
    int ptCount;

    mapping (int => trademark) private tms;
    int tmCount;

    event crRegisComplete (string crName, address[] crOwner, uint crRegisTime);
    event ptRegisComplete (string ptName, address[] ptOwner, uint ptRegisTime, uint ptExpireTime);
    event tmRegisComplete (string tmName, address[] tmOwner, uint tmRegisTime, uint tmExpireTime);
    event transactionComplete (int ipIdx, bytes32 ipUniqueNo);

    function crRegis (string memory _crName,     
                      string memory _crType,
                      address[] memory _crCreator,
                      address[] memory _crOwner)
        public returns (int, bytes32) {
            int crIdx = crCount + 1;
            copyright storage copyrights = crs[crIdx];
            copyrights.crNo = crIdx;
            copyrights.crName = _crName;
            copyrights.crType = _crType;
            copyrights.crCreator = _crCreator;
            copyrights.crOwner = _crOwner;
            copyrights.crRegisTime = block.timestamp;
            copyrights.crUniqueNo = keccak256(bytes(_crName));

            crCount ++;

            emit crRegisComplete (_crName, copyrights.crOwner, block.timestamp);
            return (crIdx, copyrights.crUniqueNo);
        }
    
    function ptRegis (string memory _ptName, 
                      string memory _ptType,    
                      address[] memory _ptCreator,
                      address[] memory _ptOwner)
        public returns (int, bytes32) {
            int ptIdx = ptCount + 1;
            patent storage patents = pts[ptIdx];
            patents.ptNo = ptIdx;
            patents.ptName = _ptName;
            patents.ptType = _ptType;
            patents.ptCreator = _ptCreator;
            patents.ptOwner = _ptOwner;
            patents.ptRegisTime = block.timestamp;
            patents.ptExpireTime = patents.ptRegisTime + 631065600;
            patents.ptUniqueNo = keccak256(bytes(_ptName));

            ptCount ++;

            emit ptRegisComplete (_ptName, patents.ptOwner, block.timestamp, patents.ptExpireTime);
            return (ptIdx, patents.ptUniqueNo);
        }

    function tmRegis (string memory _tmName, 
                      string memory _tmRange,
                      address[] memory _tmDesigner,
                      address[] memory _tmOwner)
        public returns (int, bytes32) {
            int tmIdx = tmCount + 1;
            trademark storage trademarks = tms[tmIdx];
            trademarks.tmNo = tmIdx;
            trademarks.tmName = _tmName;
            trademarks.tmRange = _tmRange;
            trademarks.tmDesigner = _tmDesigner;
            trademarks.tmOwner = _tmOwner;
            trademarks.tmRegisTime = block.timestamp;
            trademarks.tmExpireTime = trademarks.tmRegisTime + 315532800;
            trademarks.tmUniqueNo = keccak256(bytes(_tmName));

            tmCount ++;

            emit tmRegisComplete (_tmName, trademarks.tmOwner, block.timestamp, trademarks.tmExpireTime);
            return (tmIdx, trademarks.tmUniqueNo);
        }
    
    function crSearch (int _crIdx)
        public view returns (string memory crName,
                             string memory crType,
                             address[] memory crCreator,
                             address[] memory crOwner,
                             uint crRegisTime,
                             bytes32 crUniqueNo) {
            require(_crIdx <= crCount, "invalid copyright id number");
            copyright storage copyrights = crs[_crIdx];
            crName = copyrights.crName;
            crType = copyrights.crType;
            crCreator = copyrights.crCreator;
            crOwner = copyrights.crOwner;
            crRegisTime = copyrights.crRegisTime;
            crUniqueNo = copyrights.crUniqueNo;
            }

    function ptSearch (int _ptIdx)
        public view returns (string memory ptName,
                             string memory ptType,
                             address[] memory ptCreator,
                             address[] memory ptOwner,
                             uint ptRegisTime,
                             uint ptExpireTime,
                             bytes32 ptUniqueNo) {
            require(_ptIdx <= ptCount, "invalid patent id number");
            patent storage patents = pts[_ptIdx];
            ptName = patents.ptName;
            ptType = patents.ptType;
            ptCreator = patents.ptCreator;
            ptOwner = patents.ptOwner;
            ptRegisTime = patents.ptRegisTime;
            ptExpireTime = patents.ptExpireTime;
            ptUniqueNo = patents.ptUniqueNo;
            }

     function tmSearch (int _tmIdx)
        public view returns (string memory tmName,
                             string memory tmRange,
                             address[] memory tmDesigner,
                             address[] memory tmOwner,
                             uint tmRegisTime,
                             uint tmExpireTime,
                             bytes32 tmUniqueNo) {
            require(_tmIdx <= tmCount, "invalid trademark id number");
            trademark storage trademarks = tms[_tmIdx];
            tmName = trademarks.tmName;
            tmDesigner = trademarks.tmDesigner;
            tmOwner = trademarks.tmOwner;
            tmRange = trademarks.tmRange;
            tmRegisTime = trademarks.tmRegisTime;
            tmExpireTime = trademarks.tmExpireTime;
            tmUniqueNo = trademarks.tmUniqueNo;
            }
    
    function ipTransaction (int _ipIdx, 
                            bytes32 _ipUniqueNo, 
                            address _ipOwner, 
                            address[] memory _newOwner) 
        public returns (int) {
            
            copyright storage copyrights = crs[_ipIdx];
            patent storage patents = pts[_ipIdx];
            trademark storage trademarks = tms[_ipIdx];
            
            require(_ipOwner == msg.sender, 
                    "only IP owner can raise a change in ownership");
            require(_ipIdx <= crCount || 
                    _ipIdx <= ptCount || 
                    _ipIdx <= tmCount, 
                    "invalid IP id number");
            require(_ipUniqueNo == copyrights.crUniqueNo || 
                    _ipUniqueNo == patents.ptUniqueNo || 
                    _ipUniqueNo == trademarks.tmUniqueNo, 
                    "IP not exist");
            require(crs[_ipIdx].crUniqueNo == _ipUniqueNo || 
                    pts[_ipIdx].ptUniqueNo == _ipUniqueNo || 
                    tms[_ipIdx].tmUniqueNo == _ipUniqueNo, 
                    "IP index and unique number not matching");
            
            if (crs[_ipIdx].crUniqueNo == _ipUniqueNo) {
                copyrights.crOwner = _newOwner;
                copyrights.crRegisTime = block.timestamp;
            } else if (pts[_ipIdx].ptUniqueNo == _ipUniqueNo) {
                patents.ptOwner = _newOwner;
                patents.ptRegisTime = block.timestamp;
            } else if (tms[_ipIdx].tmUniqueNo == _ipUniqueNo) {
                trademarks.tmOwner = _newOwner;
                trademarks.tmRegisTime = block.timestamp;
            }

            emit transactionComplete (_ipIdx, _ipUniqueNo);
            return 0;
            }

}