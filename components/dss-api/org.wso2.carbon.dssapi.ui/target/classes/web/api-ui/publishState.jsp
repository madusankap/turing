<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:bundle basename="org.wso2.carbon.dssapi.ui.i18n.Resources">

    <%
        boolean APIAvailability = Boolean.valueOf(request.getAttribute("APIAvailability").toString());
    %>
    <table class="styledLeft" id="apiOperationsTable" style="margin-left: 0;" width="100%">
        <thead>
        <tr>
            <th colspan="2" align="left"><fmt:message key="api.operations"/></th>
        </tr>
        </thead>
        <tr>
            <td><fmt:message key="api.availability"/></td>
            <%
                if (APIAvailability) {
            %>
            <td style="background:url(images/activate.gif) no-repeat left center"> &nbsp;&nbsp;&nbsp;API is Available
                [ <a href="#" onclick="changeState(false);return false;">Unpublish API</a> ]
            </td>
            <%
            } else {
            %>
            <td style="background:url(images/deactivate.gif) no-repeat left center"> &nbsp;&nbsp;&nbsp;API is not
                Available [ <a href="#" onclick="changeState(true);return false;">Publish an API</a> ]
            </td>
            <%
                }
            %>
        </tr>
    </table>
</fmt:bundle>
