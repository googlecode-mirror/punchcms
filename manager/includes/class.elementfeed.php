<?php

/* ElementFeed Class v0.1.0
 * Handles ElementFeed properties and methods.
 *
 * CHANGELOG
 * version 0.1.0, 25 Jul 2007
 *   NEW: Created class.
 */

class ElementFeed extends DBA_ElementFeed {

	public static function selectByElement($intElementId) {
		global $_CONF;
	
		$objReturn = NULL;
	
		$strSql = "SELECT pcms_element_feed.* 
					FROM pcms_element_feed, pcms_element 
					WHERE pcms_element_feed.elementId = '%s' 
					AND pcms_element.accountId = '%s' 
					AND pcms_element_feed.elementId = pcms_element.id";
		$strSql = sprintf($strSql, quote_smart($intElementId), quote_smart($_CONF['app']['account']->getId()));
		$objReturn = self::select($strSql);
		
		return $objReturn;
	}

}

?>