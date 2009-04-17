﻿/**
 * PCMSClient 1.1 : Punch CMS : The developers CMS - http://www.mypunch.org/pcms/
 * 
 */

import com.felixit.pcms.PCMSField;
import com.felixit.pcms.PCMSElement;
import com.felixit.pcms.SWFAddress;

class com.felixit.pcms.PCMSClient {
	private var __objCms:Object;
	private var __xmlLoaded:Boolean;
	private var __objXml:XML;
	private var __ready:Boolean;
	private static var __instance:PCMSClient;
	
	private function __extendAS():Void {
		//*** XML to Object parser.
		XMLNode.prototype._mxr = function(f){return this[0][f];}
		XMLNode.prototype._mxp = function(xObj, obj) {
			var c, nName, nType, cNode, cId;
			//----- Add attributes to the object
			obj.attributes = {};
			var oa = obj.attributes;
			var xa = xObj.attributes;
			for (c in xa) oa[c] = xa[c];
			//----- Build child nodes
			for (c in xObj.childNodes) {
				cNode = xObj.childNodes[c];
				nName = cNode.nodeName;
				nType = cNode.nodeType;
				if (nType == 3) {
					obj._value = cNode.nodeValue;
				}else if (nType == 1 && nName != null) {
					if (!(obj[nName] instanceof Array)){
						obj[nName] = new Array();
						obj[nName].__resolve = this._mxr;				
						_global.ASSetPropFlags(obj[nName],null,1,1);
					}
					var sObj = this._mxp(cNode, {}); 
					obj[nName].unshift(sObj);
					// comment the next line to disable id-attribute hooks
					cId = cNode.attributes.id; if (cId!=undefined and obj[cId]==undefined) obj[cId] = sObj;
				}
			}
			// Return object
			return obj;
		};
		//wrapper for _mxp
		XMLNode.prototype.makeXMLSA = function(noRoot) {
			return (noRoot==true) ? this._mxp(this.firstChild,{}) : this._mxp(this,{});
		};
		//hide from for..in
		_global.ASSetPropFlags(XMLNode.prototype,['makeXMLSA','_mxp','_mxr'],1,1);
	}
	
	private function __loadXML(strUrl:String):Void {
		//*** Load the PunchCMS XML data.
		var __this:PCMSClient = this;
		__xmlLoaded = false;
		__objXml = new XML();
		__objXml.ignoreWhite = true;	
		__objXml.onLoad = function(success:Boolean) {
			if (success) {
				trace("loaded CMS XML");
				__this.__objCms = this.makeXMLSA(true);
				__this.__xmlLoaded = true;
				__this.__ready = true;
			} else {
				trace("error loading CMS XML");
			}
		}
		trace("loading CMS XML");
		__objXml.load(strUrl);
	}
	
	private function __getElementById(objElements:Array, intId:Number) {
		var objReturn = undefined;
		
		for (var intElement in objElements) {
			if (objElements[intElement].id == intId) {
				objReturn = objElements[intElement];
				break;
			} else {
				var objTemp = __getElementById(objElements[intElement].getElements(), intId);
				if (objTemp) {
					objReturn = objTemp;
					break;
				}
			}
		}
		
		return objReturn;
	}
	
	private function __getElementByAddress(objElements:Array, strAddress:String) {
		var objReturn = undefined;
		
		for (var intElement in objElements) {
			if (objElements[intElement].address == strAddress) {
				objReturn = objElements[intElement];
				break;
			} else {
				var objTemp = __getElementByAddress(objElements[intElement].getElements(), strAddress);
				if (objTemp) {
					objReturn = objTemp;
					break;
				}
			}
		}
		
		return objReturn;
	}
	
	public function PCMSClient(strUrl) {
		__ready = false;
		__extendAS();
		__loadXML(strUrl);
		
		PCMSClient.__instance = this;
	}
	
	public function get ready():Boolean {
		return __ready;
	}
	
	public function get address():SWFAddress {
		return SWFAddress;
	}
	
	public function setAddress(strLink:String) {
		if (strLink != "") {
			if (strLink == "//") strLink = "/";
			SWFAddress.setValue(strLink);
			trace("Set address: " + strLink);
		}
	}
	
	public function setAddressById(intPageId:Number) {
		if (intPageId > 0) {
			var objElement:PCMSElement = getElementById(intPageId);
			if (objElement && objElement.address != "") {
				setAddress(objElement.address);
			}
		}
	}
	
	public function getBytesLoaded():Number {
		return __objXml.getBytesLoaded();
	}
	
	public function getBytesTotal():Number {
		return __objXml.getBytesTotal();
	}
	
	public static function getInstance():PCMSClient {
		return PCMSClient.__instance;
	}
	
	public function getElements():Array {
		var objReturn:Array = new Array();
		
		for (var intElement = __objCms.element.length; intElement > 0; intElement--) {
			var objElement = new PCMSElement(__objCms.element[intElement - 1]);
			objReturn.push(objElement);
		}
		
		return objReturn;
	}
	
	public function getConfig(strName:String):String {		
		var strReturn = "";
		
		for (var intConfig in __objCms.configContainer.config) {
			var objConfig = __objCms.configContainer.config[intConfig];
			if (objConfig.attributes.name == strName) {
				strReturn = objConfig._value;
				break;
			}
		}
		
		return strReturn;
	}
	
	public function getElementById(intId:Number):PCMSElement {
		var objReturn = __getElementById(getElements(), intId);
		
		return objReturn;
	}
	
	public function getElementByAddress(strAddress:String):PCMSElement {
		var objReturn = __getElementByAddress(getElements(), strAddress);
		
		return objReturn;
	}
	
	public function getPageId() {
		var intReturn:Number = 0;
		
		var strAddress:String = SWFAddress.getValue();
		var objElement:PCMSElement = getElementByAddress(strAddress);
		
		if (objElement) intReturn = objElement.id;
		
		return intReturn;
	}
}