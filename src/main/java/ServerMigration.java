import com.okta.authn.sdk.AuthenticationException;
import com.okta.authn.sdk.client.AuthenticationClient;
import com.okta.authn.sdk.client.AuthenticationClients;
import com.okta.authn.sdk.resource.AuthenticationResponse;
import com.okta.authn.sdk.resource.AuthenticationStatus;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ServerMigration extends HttpServlet {
    private static final long serialVersionUID = -4751096228274971485L;

    @Override
    protected void doGet(HttpServletRequest reqest, HttpServletResponse response)
            throws ServletException, IOException {
        AuthenticationClient authClient = AuthenticationClients.builder()
                .build();

        String username = "proxy";
        String password ="Password1!";
        String relayState ="";
        ExampleAuthenticationStateHandler catchMfaHandler = new ExampleAuthenticationStateHandler();

        try {
            AuthenticationResponse authenticate = authClient.authenticate(username, password.toCharArray(), relayState, catchMfaHandler);
            if(authenticate.getStatus() == AuthenticationStatus.MFA_REQUIRED)
            {
                reqest.setAttribute("oktaStateToken",authenticate.getStateToken());
                reqest.getRequestDispatcher("/login").forward(reqest, response);
            }
        } catch (AuthenticationException e) {
            if(e.getCode().compareTo("E0000004") == 0)
            {
                //migrate user
            }
        }
        response.getWriter().println("Hello World!");
    }


    @Override
    public void init() throws ServletException {
        System.out.println("Servlet " + this.getServletName() + " has started");
    }
    @Override
    public void destroy() {
        System.out.println("Servlet " + this.getServletName() + " has stopped");
    }
}