<!--
~ Copyright (c) 2005-2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
~
~ WSO2 Inc. licenses this file to you under the Apache License,
~ Version 2.0 (the "License"); you may not use this file except
~ in compliance with the License.
~ You may obtain a copy of the License at
~
~ http://www.apache.org/licenses/LICENSE-2.0
~
~ Unless required by applicable law or agreed to in writing,
~ software distributed under the License is distributed on an
~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~ KIND, either express or implied. See the License for the
~ specific language governing permissions and limitations
~ under the License.
-->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.dssapi.ui.APIPublisherClient" %>
<%@ page import="org.wso2.carbon.service.mgt.xsd.ServiceMetaData" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.ui.util.CharacterEncoder" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>

<%
    response.setHeader("Cache-Control", "no-cache");
    String serviceName = CharacterEncoder.getSafeText(request.getParameter("serviceName"));
%>
<%

    String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

    String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);
    APIPublisherClient client;
    ServiceMetaData service;
    try {
        client = new APIPublisherClient(cookie, backendServerURL, configContext);
        service = client.getServiceData(serviceName).getServices()[0];

        boolean APIAvailability = client.isAPIAvailable(service);
        request.setAttribute("APIAvailability", APIAvailability);
    } catch (Exception e) {
        response.setStatus(500);
        CarbonUIMessage uiMsg = new CarbonUIMessage(CarbonUIMessage.ERROR, e.getMessage(), e);
        session.setAttribute(CarbonUIMessage.ID, uiMsg);
%>
<script type="text/javascript">
    location.href = "error.jsp";
</script>
<%
        return;
    }
%>

<fmt:bundle basename="org.wso2.carbon.dssapi.ui.i18n.Resources">
    <carbon:breadcrumb label="api.dashboard" resourceBundle="org.wso2.carbon.dssapi.ui.i18n.Resources" topPage="false"
                       request="<%=request%>"/>
    <div id="middle">
        <h2><fmt:message key="api.dashboard"/> (<%= serviceName %>)</h2>

        <div id="workArea">
            <div id="result">

            </div>
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <tr>
                    <td width="50%">
                        <table class="styledLeft" id="serviceGroupTable" width="50%">
                            <thead>
                            <tr>
                                <th colspan="2" align="left"><fmt:message key="service.details"/></th>
                            </tr>
                            </thead>
                            <tr>
                                <td width="30%">Service Name</td>
                                <td><%=service.getName()%>
                                </td>
                            </tr>
                            <tr>
                                <td>Description</td>
                                <td><%=service.getDescription()%>
                                </td>
                            </tr>
                            <tr>
                                <td>Service Group</td>
                                <td><%=service.getServiceGroupName()%>
                                </td>
                            </tr>
                            <tr>
                                <td>Service Scope</td>
                                <td><%=service.getScope()%>
                                </td>
                            </tr>
                            <tr>
                                <td>Service Type</td>
                                <td>
                                    <%=service.getServiceType()%>&nbsp;&nbsp;&nbsp;
                                    <img src="../<%= service.getServiceType()%>/images/type.gif"
                                         title="<%= service.getServiceType()%>"
                                         alt="<%= service.getServiceType()%>"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Deployed Time</td>
                                <td><%=service.getServiceDeployedTime()%>
                                </td>
                            </tr>
                            <tr>
                                <td>Service up time</td>
                                <td><%=service.getServiceUpTime()%>
                                </td>
                            </tr>
                        </table>
                    </td>

                    <td width="12px">&nbsp;</td>

                    <td width="50%">
                        <nobr>
                            <div id="publishStateDiv">
                                <%@ include file="publishState.jsp" %>
                            </div>
                        </nobr>
                    </td>

                    <script type="text/javascript">
                        jQuery.noConflict();
                        function changeState(active) {
                            var url = 'changeState.jsp?serviceName=<%=serviceName%>&isPublishRequest=' + active;
                            jQuery.ajax({
                                url: url,
                                type: "GET",
                                success: function () {
                                    alert("API Request sent.!! Reload the page after a few seconds. ");
                                    location.reload(true);
                                }
                            });


                            //alert(url);
                            //jQuery("#publishStateDiv").load(url, null, null );
                        }
                    </script>

                </tr>
            </table>
        </div>
    </div>
</fmt:bundle>