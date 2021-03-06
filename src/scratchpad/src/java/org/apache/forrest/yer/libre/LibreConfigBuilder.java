/*
 * The Apache Software License, Version 1.1
 *
 *
 * Copyright (c) 2001, 2002 The Apache Software Foundation.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by the
 *        Apache Software Foundation (http://www.apache.org/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "Apache Forrest" and "Apache Software Foundation" must
 *    not be used to endorse or promote products derived from this
 *    software without prior written permission. For written
 *    permission, please contact apache@apache.org.
 *
 * 5. Products derived from this software may not be called "Apache",
 *    nor may "Apache" appear in their name, without prior written
 *    permission of the Apache Software Foundation.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation and was
 * originally based on software copyright (c) 1999, International
 * Business Machines, Inc., http://www.apache.org.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 */
package org.apache.forrest.yer.libre;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.SAXException;
import org.xml.sax.Attributes;
import org.apache.forrest.yer.hierarchy.HierarchyConfig;


/** Class <code>org.apache.forrest.yer.libre.LibreConfigBuilder</code> is a helper
 *  that builds up a LibreConfig object from a stream of SAXEvents.
 *
 *  It also provides a convenience constructor that will take a simple inputStream
 *  for which it will instantiate a JAXP SAXParser that will generate the SAXEvents
 *  to this class instance.
 *
 * @author $Author: jefft $
 * @version CVS $Id: LibreConfigBuilder.java,v 1.3 2002/11/05 05:52:41 jefft Exp $
 */
public class LibreConfigBuilder extends DefaultHandler
{
  /** Default constructor.  Enables use of the LibreConfigBuilder when you
   *  have your own stream of SAX events that this ContentHandler can operate
   *  on.
   *  Note that this ContentHandler expects the used SAXParser to be namespace
   *  aware. i.e. use uri en lname args in start- and endElement events, not
   *  report xmlns:* attributes in those events.
   */
  public LibreConfigBuilder (HierarchyConfig parentCfg, LibreConfigHelper helper){
    try {
      this.parentDefinition = (LibreConfig.ChildDefinition) parentCfg;
    } catch(ClassCastException cce) {
      this.parentDefinition = null;
    }
    this.helper = helper;
  }
  /** Holds a reference to the helper object instantiated by this implementation */
  private LibreConfigHelper helper;
  /** Holds the LibreConfig object as built up from the SAXEvents */
  private LibreConfig libre;
  /** Holds the LibreConfig.ChildDefinition object for which current SAXEvents
   *  are reporting setup info. Helper object during parsing/interpretation
   *  of the libre.xml
   */
  private LibreConfig.ChildDefinition currentChild;
  /** Holds the AttributeReader object for which current SAXEvents
   *  are reporting setup info. Helper object during parsing/interpretation
   *  of the libre.xml
   */
  private LibreAttributeReader currentAttributeReader;
  /** Holds the String AttributeName reflecting the attribute for which reader
   *  current SAXEvents are reporting setup info. Helper object during
   *  parsing/interpretation of the libre.xml
   */
  private String currentAttributeName;

  private boolean inverseLogic = false;
  private boolean orderDescending = false;
  private LibreConfig.ChildDefinition parentDefinition = null;

  /** Offers the built up LibreConfig object which is avaliable after handling
   *  all the SAXEvents.
   */
  public LibreConfig getLibreConfig() {
    if (this.libre == null) {
      this.libre = this.helper.DEFAULT_LIBRE_CONFIG;
    }
    return this.libre;
  }

  /** Handles startElement SAXEvent.  Dispatches based on the localName.
   * @see org.xml.sax.ContentHandler#startElement
   */
  public void startElement(String ns_uri, String lname, String qname,
                           Attributes atts) throws SAXException
  {
    if (LibreConstants.NS_URI.equals(ns_uri)){
      if (LibreConstants.LIBRE_ELM.equals(lname)){
        startLibreRootElm(atts);
      } else if (LibreConstants.ENTRY_ELM.equals(lname)) {
        startEntryChildDefElm(atts);
      } else if (LibreConstants.AUTO_ELM.equals(lname)) {
        startAutoChildDefElm(atts);
      } else if (LibreConstants.FILTER_ELM.equals(lname)) {
        startFilterDefElm(atts);
      } else if (LibreConstants.SORTER_ELM.equals(lname)) {
        startSorterDefElm(atts);
      } else if (LibreConstants.PROPERTY_ELM.equals(lname)) {
        startPropertyReaderElm(atts);
      } else if (LibreConstants.XPATH_ELM.equals(lname)) {
        startXPATHReaderElm(atts);
      } else {
        startAttributeDefElm(lname, atts);
      }
    }
  }
  /** Handles startElement SAXEvent.  Dispatches based on the localName.
   * @see org.xml.sax.ContentHandler#endElement
   */
  public void endElement(String ns_uri, String lname, String qname) throws SAXException
  {
    if (LibreConstants.NS_URI.equals(ns_uri)){
      if (LibreConstants.LIBRE_ELM.equals(lname)){
        endLibreRootElm();
      } else if (LibreConstants.ENTRY_ELM.equals(lname)) {
        endEntryChildDefElm();
      } else if (LibreConstants.AUTO_ELM.equals(lname)) {
        endAutoChildDefElm();
      } else if (LibreConstants.FILTER_ELM.equals(lname)) {
        endFilterDefElm();
      } else if (LibreConstants.SORTER_ELM.equals(lname)) {
        endSorterDefElm();
      } else if (LibreConstants.PROPERTY_ELM.equals(lname)) {
        endPropertyReaderElm();
      } else if (LibreConstants.XPATH_ELM.equals(lname)) {
        endXPATHReaderElm();
      } else {
        endAttributeDefElm(lname);
      }
    }
  }
  /** Handles <libre> in the xml input-stream
   *  Initializes the LibreConfig object to build.
   */
  public void startLibreRootElm(Attributes atts){
    //<libre>
    this.libre = new LibreConfig();
    this.currentChild = null;
    this.currentAttributeName = null;
  }
  /** Handles <entry location".." > in the xml input.
   *  Adds appropriate childDefinition to the LibreConfig, and remembers it
   *  for setting nested configuration info.
   */
  public void startEntryChildDefElm(Attributes atts){
    //could add extra checking: if (this.currentChild != null) return;
    String location_att = atts.getValue(LibreConstants.LOCATION_ATT);
    this.currentChild = this.libre.new EntryChildDefinition(location_att);
    this.currentChild.inheritDefinition(this.parentDefinition);
    this.libre.addChildDefinition(this.currentChild);
  }

  /** Handles <auto> in the xml input.
   *  Adds appropriate childDefinition to the LibreConfig, and remembers it
   *  for setting nested configuration info.
   */
  public void startAutoChildDefElm(Attributes atts) {
    //could add extra checking: if (this.currentChild != null) return;
    this.currentChild = this.libre.new AutoChildDefinition();
    this.currentChild.inheritDefinition(this.parentDefinition);
    this.libre.addChildDefinition(this.currentChild);
  }

  /** Handles <filter> in the xml input.
   *
   */
  public void startFilterDefElm(Attributes atts){
    this.currentAttributeName = LibreConstants.FILTER_ELM;
    String logic = atts.getValue(LibreConstants.LOGIC_ATT);
    this.inverseLogic = (LibreConstants.LOGIC_VAL_INVERSE.equals(logic));
    String clear = atts.getValue(LibreConstants.CLEAR_ATT);
    if (LibreConstants.CLEAR_VAL_TRUE.equals(clear)){
      this.currentAttributeReader = this.helper.getDefaultFilter();
    }
  }
  /** Handles <sorter> in the xml input.
   *
   */
  public void startSorterDefElm(Attributes atts){
    this.currentAttributeName = LibreConstants.SORTER_ELM;
    String order = atts.getValue(LibreConstants.ORDER_ATT);
    this.orderDescending = (LibreConstants.ORDER_VAL_DESCENDING.equals(order));
    String clear = atts.getValue(LibreConstants.CLEAR_ATT);
    if (LibreConstants.CLEAR_VAL_TRUE.equals(clear)){
      this.currentAttributeReader = this.helper.getDefaultSorter();
    }
  }
  /** Handles <property mask="" regex="" subistute="" name=""/> in the xml input.
   *
   */
  public void startPropertyReaderElm(Attributes atts){
    String name = atts.getValue(LibreConstants.NAME_ATT);
    String mask = atts.getValue(LibreConstants.MASK_ATT);
    String regex = atts.getValue(LibreConstants.REGEX_ATT);
    String substitute = atts.getValue(LibreConstants.SUBSTITUTE_ATT);
    this.currentAttributeReader = this.helper.createPropertyAttributeReader(name, mask, regex, substitute);
  }
  /** Handles <xpath expression="" /> in the xml input.
   *
   */
  public void startXPATHReaderElm(Attributes atts){
    String expression = atts.getValue(LibreConstants.EXPRESSION_ATT);
    this.currentAttributeReader = this.helper.createXPathAttributeReader(expression);
  }
  /** Handles < [specific_att_name] > e.g <label> and <href>
   *
   */
  public void startAttributeDefElm(String lname, Attributes atts){
    this.currentAttributeName = lname;
  }


  /** Handles </libre> in the xml input-stream
   *  completes the reading of the LibreConfig object to build.
   */
  public void endLibreRootElm(){
  }
  /** Handles </entry> in the xml input.
   *  completes the current Child Definition.
   */
  public void endEntryChildDefElm(){
    this.currentChild = null;
  }

  /** Handles </auto> in the xml input.
   *  completes the current Child Definition.
   */
  public void endAutoChildDefElm() {
    this.currentChild = null;
  }

  /** Handles </filter> in the xml input.
   *  completes the current Child Definition.
   */
  public void endFilterDefElm(){
    this.currentAttributeReader.setInverseLogic(this.inverseLogic);
    this.currentChild.setFilterTest(this.currentAttributeReader);
    this.currentAttributeReader = null;
    this.currentAttributeName = null;
  }
  /** Handles </sorter> in the xml input.
   *  completes the current Child Definition.
   */
  public void endSorterDefElm(){
    this.currentAttributeReader.setOrderDescending(this.orderDescending);
    this.currentChild.setSortKeyGen(this.currentAttributeReader);
    this.currentAttributeReader = null;
    this.currentAttributeName = null;
  }
  /** Handles </property>
   *
   */
  public void endPropertyReaderElm(){
  }
  /** Handles </xpath>
   *
   */
  public void endXPATHReaderElm(){
  }
  /** Handles </ [specific_att_name] > e.g. </label> and </href>
   *
   */
  public void endAttributeDefElm(String lname){
    this.currentChild.setAttributeReader(this.currentAttributeName, this.currentAttributeReader);
    this.currentAttributeReader = null;
    this.currentAttributeName = null;
  }
}
