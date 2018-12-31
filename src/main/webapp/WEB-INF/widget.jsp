<%--
  Created by IntelliJ IDEA.
  User: thomaskirk
  Date: 12/30/18
  Time: 6:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String stateToken = (String)request.getAttribute("oktaStateToken"); %>

<html>
<head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <script src="https://ok1static.oktacdn.com/assets/js/sdk/okta-signin-widget/2.7.0/js/okta-sign-in.min.js" type="text/javascript"></script>
    <link href="https://ok1static.oktacdn.com/assets/js/sdk/okta-signin-widget/2.7.0/css/okta-sign-in.min.css" type="text/css" rel="stylesheet" />
    <link href="https://ok1static.oktacdn.com/assets/js/sdk/okta-signin-widget/2.7.0/css/okta-theme.css" type="text/css" rel="stylesheet" />
    <style>
        /*.primary-auth .o-form-input-name-username.o-form-control.okta-form-input-field.input-fix{display: none;}*/
    </style>
</head>
<body>
<!-- Render the login widget here -->
<div id="okta-login-container"></div>

    <!-- Script to init the widget -->
    <% if(stateToken != null && !stateToken.isEmpty()) {%>
    <script type="text/javascript">

        var oktaSignIn = new OktaSignIn({
            baseUrl: 'https://tkirk.oktapreview.com',
            stateToken: '<%= stateToken%>'
        });
    </script>
    <% }
    else
    {%>

    <script type="text/javascript">

        var oktaSignIn = new OktaSignIn({
            baseUrl: 'https://tkirk.oktapreview.com',
        });
    </script>
    <% } %>
    <script type="text/javascript">
    if (oktaSignIn.token.hasTokensInUrl()) {
        oktaSignIn.token.parseTokensFromUrl(
            function success(res) {
                // The tokens are returned in the order requested by `responseType` above
                var accessToken = res[0];
                var idToken = res[1]

                // Say hello to the person who just signed in:
                console.log('Hello, ' + idToken.claims.email);

                // Save the tokens for later use, e.g. if the page gets refreshed:
                oktaSignIn.tokenManager.add('accessToken', accessToken);
                oktaSignIn.tokenManager.add('idToken', idToken);

                // Remove the tokens from the window location hash
                window.location.hash='';
            },
            function error(err) {
                // handle errors as needed
                console.error(err);
            }
        );
    } else {
        oktaSignIn.session.get(function (res) {
            // Session exists, show logged in state.
            if (res.status === 'ACTIVE') {
                console.log('Welcome back, ' + res.login);
                window.location = 'https://google.com';

                return;
            }
            // No session, show the login form
            oktaSignIn.renderEl(
                { el: '#okta-login-container' },
                function success(res) {
                    // Nothing to do in this case, the widget will automatically redirect
                    // the user to Okta for authentication, then back to this page if successful
                    console.log('Hello! ');
                    window.location = 'https://google.com';
                },
                function error(err) {
                    // handle errors as needed
                    console.error(err);
                }
            );
        });
    }
</script>
</body>
</html>
