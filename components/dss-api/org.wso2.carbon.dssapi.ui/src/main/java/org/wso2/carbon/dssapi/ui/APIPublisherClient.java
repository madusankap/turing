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
package org.wso2.carbon.dssapi.ui;


import org.apache.axis2.AxisFault;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.ConfigurationContext;
import org.wso2.carbon.dssapi.stub.APIPublisherException;
import org.wso2.carbon.dssapi.stub.APIPublisherStub;
import org.wso2.carbon.service.mgt.xsd.ServiceMetaData;
import org.wso2.carbon.service.mgt.xsd.ServiceMetaDataWrapper;

import java.rmi.RemoteException;

/**
 * API publisher client to talk to stub
 */
public class APIPublisherClient {

    //private static Log log = LogFactory.getLog(APIPublisherClient.class);
    APIPublisherStub stub;
    ServiceMetaDataWrapper serviceMetaDataWrapper;

    public APIPublisherClient(String cookie, String url, ConfigurationContext configContext) throws AxisFault {
        String serviceEndpoint = "";

        serviceEndpoint = url + "APIPublisher";
        stub = new APIPublisherStub(configContext, serviceEndpoint);
        ServiceClient client = stub._getServiceClient();
        Options option = client.getOptions();
        option.setManageSession(true);
        option.setProperty(org.apache.axis2.transport.http.HTTPConstants.COOKIE_STRING, cookie);


    }

    /**
     * To get number of pages to display
     *
     * @return number of pages
     * @throws RemoteException
     * @throws APIPublisherException
     */
    public int getNumberOfPages() throws RemoteException, APIPublisherException {
        serviceMetaDataWrapper = stub.listDssServices("", 0);
        return serviceMetaDataWrapper.getNumberOfPages();
    }

    /**
     * To get number of active services
     *
     * @return number of active services
     * @throws RemoteException
     * @throws APIPublisherException
     */
    public int getNumberOfActiveServices() throws Exception {
        return stub.listDssServices("", 0).getNumberOfActiveServices();
    }

    /**
     * To get number of services for API operations
     *
     * @return number of services for API operations
     * @throws RemoteException
     * @throws APIPublisherException
     */
    public int getNumberOfServices() throws Exception {
        return stub.listDssServices("", 0).getServices().length;
    }

    /**
     * To get all available services
     *
     * @return all the services
     * @throws RemoteException
     * @throws APIPublisherException
     */
    public ServiceMetaData[] getServices(String searchQuery) throws RemoteException, APIPublisherException {
        return stub.listDssServices(searchQuery, 0).getServices();
    }

    /**
     * To check whether an API is available for the given service
     *
     * @param serviceMetaData service details
     * @return api availability of the given service
     * @throws RemoteException
     */
    public boolean isAPIAvailable(ServiceMetaData serviceMetaData) throws RemoteException {
        return stub.apiAvailable(serviceMetaData.getName());
    }


    /**
     * To publish API for a given service
     *
     * @param serviceMetaData service details
     * @return status of the operation
     * @throws RemoteException
     * @throws APIPublisherException
     */
    public boolean publishAPI(ServiceMetaData serviceMetaData) throws RemoteException, APIPublisherException {
        String serviceId = serviceMetaData.getName();
        return stub.addApi(serviceId);
    }

    /**
     * To un-publish API for a given service
     *
     * @param serviceMetaData service details
     * @return status of the operation
     * @throws RemoteException
     */
    public boolean unpublishAPI(ServiceMetaData serviceMetaData) throws RemoteException {
        String serviceId = serviceMetaData.getName();
        return stub.removeApi(serviceId);
    }


    /**
     * To get number of faulty services
     *
     * @param serviceMetaData service details
     * @return number of faulty service groups
     * @throws RemoteException
     * @throws APIPublisherException
     */
    public int getNumofFaultyServices(ServiceMetaData serviceMetaData) throws RemoteException, APIPublisherException {
        return stub.listDssServices("", 0).getNumberOfFaultyServiceGroups();
    }

    /**
     * To get the service details by service name
     *
     * @param serviceName name of the service
     * @return service details
     * @throws RemoteException
     * @throws APIPublisherException
     */
    public ServiceMetaDataWrapper getServiceData(String serviceName) throws RemoteException, APIPublisherException {
        return stub.listDssServices(serviceName, 0);
    }

    /**
     * To retrieve number of active subscriptions for the service
     *
     * @param serviceName name of the service
     * @return number of subscriptions
     * @throws RemoteException
     */
    public long checkNumberOfSubcriptions(String serviceName) throws RemoteException {
        return stub.viewSubscriptions(serviceName);

    }
}
