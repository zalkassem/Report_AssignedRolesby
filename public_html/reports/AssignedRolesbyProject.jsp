<!--
/*
 *  Copyright:      Copyright 2018 (c) Parametric Technology GmbH
 *  Product:        PTC Integrity Lifecycle Manager
 *  Author:         Volker Eckardt, Principal Consultant ALM
 *  Purpose:        Custom Developed Code
 *  **************  File Version Details  **************
 *  Revision:       $Revision: 1.3 $
 *  Last changed:   $Date: 2018/05/18 02:18:19CET $
 */
 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="utf-8"%>
<html>
  <head>
    <title>Assigned Roles by Project</title>
    <link rel="stylesheet" type="text/css" href="css/integritydocs.css">
    <script type="text/javascript" src="css/sorttable.js"></script>
  </head>

  <body>

    <%@ page import="mks.ci.server.engine.LocalTriggerManager.*" isThreadSafe="false"%>
    <%@ page import="mks.ci.server.engine.*" isThreadSafe="false"%>
    <%@ page import="java.sql.*" isThreadSafe="false"%>
    <%@ page import="mks.ci.common.*" isThreadSafe="false"%>

    <div class="common-header"><div class="logo">&nbsp;</div></div>

    <jsp:useBean id = "date" class = "java.util.Date" /> 
    <p class="date"><%= date %></p>


    <%
      Connection conn = null;
      CISignature sig = null;
      //
      // MUST BE UPDATED TO REFLECT A VALID SYSTEM USER (use 'im users --fields=id,name' to get a proper id)
      // 
      int defaultUserID = 1;
      //
      // ScriptServerBean(int userId, Connection c, CISignature sig)
      ScriptServerBean ssb = new ScriptServerBean(defaultUserID, conn, sig);
      // out.println("<br>getCurrentUser: " + ssb.getCurrentUser());
      String currUser = ssb.getCurrentUser();
      if (request.getParameter("username") != null) {
        currUser = request.getParameter("username");
      }  

      ScriptUserBean sub = ssb.getUserBean(currUser);
      String fullName = sub.getFullName();

    %>
    <h1>&nbsp;</h1>
    <h1 align="center">Assigned Roles by Project</h1>
    <h3 align="center">for User: <%=fullName%>&nbsp;(<%=currUser%>)</h3>
    <%

      String[] projects = new String[1];
      //     out.println("<br>Projects Length " + projects.length);
      //     for (String project: projects) {     
      //      out.println("<br>&nbsp;&nbsp;Project " + project);
      //     }

      if (request.getParameter("project") != null) {
        projects[0] = request.getParameter("project");
      } else {
        projects = ssb.getProjects();
      }

      String[] dynamicGroups = ssb.getDynamicGroups();
      // out.println("<br>dynamicGroups Length " + dynamicGroups.length);

      String[] userGroups = sub.getGroups();  
//           out.println("<br>userGroups Length " + userGroups.length);
//           for (String group: userGroups) {     
//            out.println("<br>&nbsp;&nbsp;Group " + group);
//           }

    %>
    <table class='sortable' align="center">
      <thead><tr><th class='heading1'>Project</th><th class='heading1'>Role Assignments (Dynamic Groups)</th></tr></thead>
      <tbody>
        <%
          int cnt = 0;
          for (String project: projects) { 
            for (String group: dynamicGroups) {     
              ScriptDynamicGroupBean dgb = ssb.getDynamicGroupBean(group); 
              Boolean isMember = dgb.isUserMemberOf(currUser, project);
              if (isMember) {
                cnt++;
                // out.println(project);
                // out.println(group);
                %>
                <tr>
                  <td><big><%=project%></big></td>
                  <td><big><%=group%></big></td>
                </tr>
                <%
              }
            }
          }
          %>
                <tfoot><tr>
                  <td>Count:&nbsp;<%=cnt%></td>
                  <td>&nbsp;</td>
                </tr></tfoot>
          <%  
        %>
      </tbody>  
    </table>
    <br>
    <table class='sortable' align="center">
      <thead><tr><th class='heading1'>Group Assignments</th></tr></thead>
      <tbody>
        <%
            for (String group: userGroups) {     
                %>
                <tr>
                  <td><big><%=group%></big></td>
                </tr>
                <%
            }
            %>
                <tfoot><tr>
                  <td>Count:&nbsp;<%=userGroups.length%></td>
                </tr></tfoot>            
            <%
          
        %>
      </tbody>  
     </table>      

<!--script type="text/javascript">
  var serverBean = mgr.lookupBean("imServerBean");
  document.writeln("Current User = " + serverBean.getCurrentUser());
</script -->
<br><center class="footer">&copy;&nbsp;Copyright&nbsp;2018&nbsp;PTC</center>

</body>
</html>