// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/log;
import ballerina/io;
import cafe.tea as _;

service http:Service /coffe on new http:Listener(9090) {
    @http:ResourceConfig {
            produces: ["application/json"]
    }
    resource function get menu(http:Caller caller, http:Request req) {
        http:Response res = new;
        json|error rResult = read("./menus/coffe.json");
        if (rResult is error) {
            log:printError("Error occurred while reading json: ",err = rResult);
        } else {
            res.setJsonPayload(<@untainted> rResult);
        }
        var result = caller->respond(res);
        if (result is error) {
            log:printError("Error in responding", err = result);
        }
    }
}

function read(string path) returns @tainted json|error {
    io:ReadableByteChannel rbc = check io:openReadableFile(path);
    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    var isClosed = rch.close();
    if (isClosed is error) {
        log:printError("Error occurred while closing character stream", err = isClosed);
    }
    return result;
}
