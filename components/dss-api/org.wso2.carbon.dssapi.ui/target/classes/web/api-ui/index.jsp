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

<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.CarbonError" %>
<%@ page import="org.wso2.carbon.dssapi.ui.APIPublisherClient" %>
<%@ page import="org.wso2.carbon.service.mgt.xsd.ServiceMetaData" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>


<link href="<c:url value='css/custom.css' />" rel="stylesheet">

<%
    response.setHeader("Cache-Control", "no-cache");
    APIPublisherClient apiPublisherClient = null;
    int numServices = 0;
    ServiceMetaData[] serviceList = null;

    try {
        String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
        ConfigurationContext configContext =
                (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
        String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);

        apiPublisherClient = new APIPublisherClient(cookie, backendServerURL, configContext);
        serviceList = apiPublisherClient.getServices("");
        numServices = serviceList.length;
    } catch (Exception e) {
        CarbonError carbonError = new CarbonError();
        carbonError.addError("Error occurred while saving data service configuration.");
        request.setAttribute(CarbonError.ID, carbonError);
        String errorMsg = e.getMessage();
%>

<script type="text/javascript">
    location.href = "error.jsp";
</script>
<%
    }
%>
<carbon:breadcrumb label="api.publisher" resourceBundle="org.wso2.carbon.dssapi.ui.i18n.Resources" topPage="false"
                   request="<%=request%>"/>

<div id="middle">
    <h2>API Publisher Console</h2>

    <div id="workArea">
        <label><%=numServices%> active service(s)</label>
        <table class="styledLeft" id="servicesTable">
            <thead>
            <tr>
                <th colspan="5">Services</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (serviceList != null) {
                    int position = 0;
                    for (ServiceMetaData service : serviceList) {
                        String bgColor = ((position % 2) == 1) ? "#EEEFFB" : "white";
                        position++;
            %>
            <tr style="background-color: <%=bgColor%>">
                <td><a href="serviceDetails.jsp?serviceName=<%=service.getName()%>"><%=service.getName()%>
                </a><input type="hidden" name="serviceName" value="<%=service.getName()%>"></td>
                <td><%=service.getDescription()%>
                </td>
                <td>Deployed on <%=service.getServiceDeployedTime()%>
                </td>
                <td>Service up for <%=service.getServiceUpTime()%>
                </td>
                <td><%=apiPublisherClient.isAPIAvailable(service)%>
                </td>
            </tr>
            <%
                    }
                } else {
                    //put an error message
                }
            %>
            </tbody>
        </table>
    </div>
</div>