<!--
  Copyright 2003-2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<%!
private String getTimestamp(String module, Locale loc) {
  File logFile = new File(getServletContext().getRealPath("/logs/work."+module+".log"));
  if (!logFile.exists()) return "";
  long tstamp = logFile.lastModified();
  long t0 = System.currentTimeMillis();
  long dt = t0 - tstamp;
  long secs=dt/1000;
  long mins=secs/60;
  long hours=mins/60;
  long days=hours/24;

  StringBuffer ret = new StringBuffer();

  if (days != 0) ret.append(days+" day"+(days==1?" ":"s "));
  hours -= days*24;
  if (hours != 0) ret.append(hours+" hour"+(hours==1?" ":"s "));
  mins -= (days*24 + hours)*60;
  if (mins != 0) ret.append(mins+" min"+(mins==1?" ":"s "));
  secs -= ((days*24 + hours)*60 + mins)*60;
  if (secs != 0) ret.append(secs+" sec"+(secs==1?" ":"s "));
  ret.append(" ago");
  return ret.toString();
}

private boolean hasPriv(String privs, String priv) {
  if (privs == null) return false;
  return privs.indexOf(priv) != -1;
}
%>

<%-- vim: set ft=java: --%>
