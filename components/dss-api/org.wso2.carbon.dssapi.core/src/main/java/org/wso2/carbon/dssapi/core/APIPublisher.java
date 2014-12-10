/*
 *  Copyright (c) 2005-2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 *
 */

package org.wso2.carbon.dssapi.core;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.impl.builder.StAXOMBuilder;
import org.wso2.carbon.context.CarbonContext;
import org.wso2.carbon.dataservices.common.DBConstants;
import org.wso2.carbon.dataservices.core.admin.DataServiceAdmin;
import org.wso2.carbon.dataservices.ui.beans.Data;
import org.wso2.carbon.dssapi.util.APIUtil;
import org.wso2.carbon.service.mgt.ServiceAdmin;
import org.wso2.carbon.service.mgt.ServiceMetaDataWrapper;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

/**
 * To handle the API operations
 */
public class APIPublisher {

    /**
     * To list DSS services
     *
     * @param searchString name of the service or part os a name
     * @param pageNumber   page number
     * @return List of Data Services
     * @throws Exception
     */
    public ServiceMetaDataWrapper listDssServices(String searchString, int pageNumber) throws Exception {
        return new ServiceAdmin().listServices(DBConstants.DB_SERVICE_TYPE, searchString, pageNumber);
    }

    /**
     * To check whether API is available for the given service or not
     *
     * @param ServiceName name of the service
     * @return availability of api to DataServices
     */
    public boolean apiAvailable(String ServiceName) {
        String tenantDomain = CarbonContext.getThreadLocalCarbonContext().getTenantDomain();
        String username = CarbonContext.getThreadLocalCarbonContext().getUsername();
        return new APIUtil().apiAvailable(ServiceName, username, tenantDomain);
    }

    /**
     * To check whether API have active Subscriptions for the given service or not
     *
     * @param ServiceName name of the service
     * @return no of subscriptions to api to that  DataServices
     */
    public long viewSubscriptions(String ServiceName) {
        String tenantDomain = CarbonContext.getThreadLocalCarbonContext().getTenantDomain();
        String username = CarbonContext.getThreadLocalCarbonContext().getUsername();
        return new APIUtil().apiSubscriptions(ServiceName, username, tenantDomain);
    }
    /**
     * To add an API for a service
     *
     * @param serviceId service id of the service
     * @throws Exception
     */
    public boolean addApi(String serviceId) {
        String serviceContents;
        boolean Status = false;
        try {
            serviceContents = new DataServiceAdmin().getDataServiceContentAsString(serviceId);
            InputStream ins = new ByteArrayInputStream(serviceContents.getBytes());
            OMElement configElement = (new StAXOMBuilder(ins)).getDocumentElement();
            configElement.build();
            Data data = new Data();
            data.populate(configElement);
            data.setManagedApi(true);
            new DataServiceAdmin().saveDataService(serviceId, "", data.buildXML().toString());
            String tenantDomain = CarbonContext.getThreadLocalCarbonContext().getTenantDomain();
            String username = CarbonContext.getThreadLocalCarbonContext().getUsername();
            new APIUtil().addApi(serviceId, username, tenantDomain,data);
            Status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Status;

    }

    /**
     * To remove the API
     *
     * @param serviceId service id of the service
     * @return api is removed from api manager
     */
    public boolean removeApi(String serviceId) {
        String serviceContents;
        boolean Status = false;
        try {
            serviceContents = new DataServiceAdmin().getDataServiceContentAsString(serviceId);
            InputStream ins = new ByteArrayInputStream(serviceContents.getBytes());
            OMElement configElement = (new StAXOMBuilder(ins)).getDocumentElement();
            configElement.build();
            Data data = new Data();
            data.populate(configElement);
            data.setManagedApi(false);
            new DataServiceAdmin().saveDataService(serviceId, "", data.buildXML().toString());
            String tenantDomain = CarbonContext.getThreadLocalCarbonContext().getTenantDomain();
            String username = CarbonContext.getThreadLocalCarbonContext().getUsername();
            new APIUtil().removeApi(serviceId, username, tenantDomain);
            Status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Status;
    }
}
