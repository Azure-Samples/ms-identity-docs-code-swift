---
# Metadata required by https://learn.microsoft.com/samples/browse/
# Metadata properties: https://review.learn.microsoft.com/help/contribute/samples/process/onboarding?branch=main#add-metadata-to-readme
languages:
- swift 
page_type: sample
name: SwiftUI Multiplatform app that makes a request to the Graph API after signing in the user
description: This Swift 5.5 Multiplatform SwiftUI iOS and macOS app signs in the user and then makes a request to Microsoft Graph for the user's profile data.
products:
- azure
- azure-active-directory
- ms-graph
urlFragment: ms-identity-docs-code-app-swift-multiplatform
---

# Swift | Multiplatform SwiftUI iOS and macOS | user sign-in, protected web API access (Microsoft Graph) | Microsoft identity platform

<!-- Build badges here
![Build passing.](https://img.shields.io/badge/build-passing-brightgreen.svg) ![Code coverage.](https://img.shields.io/badge/coverage-100%25-brightgreen.svg) ![License.](https://img.shields.io/badge/license-MIT-green.svg)
-->

This Swift 5.5 Multiplatform SwiftUI iOS and macOS app authenticates a user and then makes a request to the Graph API as the authenticated user. The response to the request is presented to the user.

![A screenshot of a Swift 5.5 Multiplatform SwiftUI iOS app displaying a response from Microsoft Graph.](./ios-signout-app.png)

![A screenshot of a Swift 5.5 Multiplatform SwiftUI macOS app displaying a response from Microsoft Graph.](./macos-signout-app.png)

## Prerequisites

- A Microsoft Entra tenant and the permissions or role required for managing app registrations in the tenant.
- Xcode 13.2.1
- Swift 5+
- [Apple ID](https://help.apple.com/developer-account/#/devadf555df9)

## Setup

### 1. Register the app

First, complete the steps in [Register an application with the Microsoft identity platform](https://learn.microsoft.com/en-us/azure/active-directory/develop/tutorial-v2-ios#register-your-application) to register the application.

Use these settings in your app registration.

| App registration <br/> setting  | Value for this sample app                                           | Notes                                                                           |
|--------------------------------:|:--------------------------------------------------------------------|:--------------------------------------------------------------------------------|
| **Name**                        | `active-directory-swift-ios-macos-authorization-code-grant-flow`    | Suggested value for this sample. <br/> You can change the app name at any time. |
| **Supported account types**     | **Accounts in this organizational directory only (Single tenant)**  | Suggested value for this sample.                                                |
| **Platform type**               | **iOS / macOS **                                                    | Required value for this sample                                                  |
| **Redirect URIs**               | `msauth.com.contoso.msalExample-macOS://auth` and `msauth.com.contoso.msalExample-iOS://auth` | Required value for this sample                    |

> :information_source: **Bold text** in the tables above matches (or is similar to) a UI element in the  Microsoft Entra admin center, while `code formatting` indicates a value you enter into a text box in the Microsoft Entra admin center.

### 2. Open the project in Xcode 

Next, open the _msalexamples-ios-macos.xcodeproj_ project in Xcode.

### 3. Update code sample in MSALAuthentication.swift_ with app registration values

Finally, set the following values in _Shared/MSALAuthentication.swift_.

```swift
// 'Application (client) ID' of app registration in the Microsoft Entra admin center - this value is a GUID
private static let kClientId = "Enter_the_Application_Id_Here"

// 'Tenant ID' of your Microsoft Entra instance - this value is a GUID
private static let kTenantId = "Enter_the_Tenant_ID_Here"
```

### 4. Select a development team in the Signing & Capabilities editor

1. Navigate to the *msalExamples-iOS* target under the project *msalexamples-ios-macos*.
1. Select **Signing & Capabilities**.
1. Under **Signing** > **Team**, select **Add Account...**.
1. Follow the instructions using your Apple ID to add your account.
1. Select the added Apple ID account from the **Team** list.
1. Navigate to the *msalExamples-macOS* target under the project *msalexamples-ios-macos*.
1. Under **Signing** > **Team**, select the recently added Apple ID account.

   > Note: This configuration is required for signing your applications that are making use of the Keychain Groups capabilities. For further information, please refer to [Keychain groups](https://learn.microsoft.com/azure/active-directory/develop/howto-v2-keychain-objc?tabs=objc).

## Run the application

Select **My Mac** or any iOS simulator and then select :arrow_forward: 

:warning: running the application for the first time kicks off a new build, and as part of this process you might be requested to enter the **"login", keychain password** to allow codesign access your Apple ID account key in your keychain.

The application will open, allowing you to click the **Sign In** button to initiate the authentication flow.

![A screenshot of a Swift 5.5 Multiplatform SwiftUI iOS app guiding the user to click the "Sign In" button.](./ios-signin-app.png)

![A screenshot of a Swift 5.5 Multiplatform SwiftUI macOS app guiding the user to click the "Sign In" button.](./macos-signin-app.png)

## About the code

This Swift 5.5 Multiplatform iOS and macOS app presents a button that initiates an authentication flow using the Microsoft Authentication Library for iOS and macOS (MSAL). The user completes this flow in their default web browser or natively in iOS. Upon successful authentication, an HTTP GET request to the Microsoft Graph /me endpoint is issued with the user's access token in the HTTP header. The response from the GET request is then displayed to the user.

This project uses Swift Package Manager dependencies to reference `MSAL` from [AzureAD/microsoft-authentication-library-for-objc](https://github.com/AzureAD/microsoft-authentication-library-for-objc). For more information, please refer to using [Swift Packages](https://github.com/AzureAD/microsoft-authentication-library-for-objc/tree/3bc25ad3c38c0f0044e3fc624a841ac4789478c0#using-swift-packages)

## Reporting problems

### Sample app not working?

If you can't get the sample working, you've checked [Stack Overflow](http://stackoverflow.com/questions/tagged/msal), and you've already searched the issues in this sample's repository, open an issue report the problem.

1. Search the [GitHub issues](/issues) in the repository - your problem might already have been reported or have an answer.
1. Nothing similar? [Open an issue](/issues/new) that clearly explains the problem you're having running the sample app.

### All other issues

> :warning: WARNING: Any issue in this repository _not_ limited to running one of its sample apps will be closed without being addressed.

For all other requests, see [Support and help options for developers](https://learn.microsoft.com/azure/active-directory/develop/developer-support-help-options).

## Contributing

If you'd like to contribute to this sample, see [CONTRIBUTING.MD](/CONTRIBUTING.md).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information, see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
