<?php
/**
 * This file is part of ValidFormBuilder.
 *
 * Copyright (c) 2008 Felix Langfeldt
 *
 * ValidFormBuilder is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * ValidFormBuilder is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with ValidFormBuilder.  If not, see <http://www.gnu.org/licenses/>.
 */
 
/**
 * VF_Note class
 *
 * @package ValidForm
 * @author Felix Langfeldt
 * @version 0.1
 */
  
require_once('class.classdynamic.php');

class VF_Note extends ClassDynamic {
	protected $__header;
	protected $__body;
	
	public function __construct($header = NULL, $body = NULL) {
		$this->__header = $header;
		$this->__body = $body;
	}
	
	public function toHtml() {
		$strOutput = "<div class=\"vf__notes\">\n";
		if (!empty($this->__header)) $strOutput .= "<h4>$this->__header</h4>\n";
		if (!empty($this->__body)) $strOutput .= "<p>{$this->__body}</p>\n";
		$strOutput .= "</div>\n";
	
		return $strOutput;
	}
	
}

?>