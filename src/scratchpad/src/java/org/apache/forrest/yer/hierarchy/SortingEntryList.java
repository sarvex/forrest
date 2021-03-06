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
package org.apache.forrest.yer.hierarchy;

import java.util.Collection;
import java.util.Comparator;
import java.util.TreeSet;
import java.util.Iterator;

/** Class <code>org.apache.forrest.yer.hierarchy.SortingEntryList</code> ...
 * 
 * @author $Author: jefft $
 * @version CVS $Id: SortingEntryList.java,v 1.3 2002/11/05 05:52:40 jefft Exp $
 */
public class SortingEntryList implements EntryList
{
  TreeSet sortedSet;
  /** Default constructor
   * 
   */
  public SortingEntryList(Comparator c)
  {
    this.sortedSet = new TreeSet(c);
  }

  /** Adds a entry to the list.
   * @param newEntry the Entry to be added.
   */
  public void addEntry(Entry newEntry)
  {
    this.sortedSet.add(newEntry);
  }

  public void copyEntries(EntryList otherEntries)
  {
     this.sortedSet.addAll(otherEntries.getMembersAsCollection());
  }

  public Collection getMembersAsCollection()
  {
    return this.sortedSet;
  }

  /** Allows for the passed object to perform an operation on all elements
   *  of the list. Mainly this function just iterates through the elements
   *  in the list, and passes each element Entry through the EntryVisitor
   *  passed as the argument to the method.
   * @param theVisitor the <code>EntryVisitor</code> that performs an action
   *  on the List.
   */
  public void visitEntries(EntryVisitor theVisitor)
  {
    Iterator iterator = this.sortedSet.iterator();
    while (iterator.hasNext()) {
      theVisitor.visit((Entry)iterator.next());
    }
  }
}
