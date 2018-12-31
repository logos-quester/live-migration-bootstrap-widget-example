import com.okta.authn.sdk.AuthenticationStateHandlerAdapter;
import com.okta.authn.sdk.resource.AuthenticationResponse;

public class ExampleAuthenticationStateHandler extends AuthenticationStateHandlerAdapter {

    public void handleUnknown(AuthenticationResponse authenticationResponse) {
        // redirect to "/error"
    }

}