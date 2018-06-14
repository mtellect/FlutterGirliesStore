package maugost.girlies;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.mukeshsolanki.sociallogin.facebook.FacebookHelper;
import com.mukeshsolanki.sociallogin.facebook.FacebookListener;
import com.mukeshsolanki.sociallogin.google.GoogleHelper;
import com.mukeshsolanki.sociallogin.instagram.InstagramHelper;
import com.mukeshsolanki.sociallogin.twitter.TwitterHelper;

import java.util.Arrays;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import maugost.girlies.creditcarddesign.CardEditActivity;
import maugost.girlies.creditcarddesign.CreditCardUtils;

import static maugost.girlies.creditcarddesign.CreditCardUtils.EMAIL;


public class MainActivity extends FlutterActivity  {
    private static final String CHANNEL = "maugost.com/paystack_flutter";
    private static final String METHOD_LOG_OUT = "logOut";
    private static final String METHOD_GET_CURRENT_ACCESS_TOKEN = "getCurrentAccessToken";
    private static final int PAYSTACK_REQUEST_CODE = 1000;
    private static final int MY_SCAN_REQUEST_CODE = 2000;
    private static final int REQUEST_CODE_SCAN_CARD = 3000;
    private Activity activity;
    private Context context;
    private MethodChannel.Result pendingResult;
    private MethodCall methodCall;
    private FacebookHelper mFacebook;
    private TwitterHelper mTwitter;
    private GoogleHelper mGoogle;
    private InstagramHelper mInstagram;
    private CallbackManager callbackManager;
    private LoginManager loginManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        FacebookSdk.setApplicationId(getResources().getString(R.string.facebook_app_id));
        FacebookSdk.sdkInitialize(this);
        AppEventsLogger.activateApp(this);
        //mFacebook = new FacebookHelper(this);
        context = this;
        activity = this;


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        // TODO
                        pendingResult = result;
                        methodCall = call;

                        switch (call.method) {
                            case "payWithPaystack":
                                paystackPay(result);
                                break;
                            case "scanAndPayPaystack":
                                //scanCard1();
                                break;
                            case "facebookLogin":
                                faceBookLogin();
                                break;
                            case "facebookLogout":
                                faceBookLogout();
                                break;
                            default:
                                result.notImplemented();
                                break;
                        }
                    }
                });
    }

    private void faceBookLogin() {
        //mFacebook.performSignIn(activity);
        activity.startActivity(new Intent(context,FacebookLogin.class));
    }
    private void faceBookLogout() {
        mFacebook.performSignOut();
    }

    private void paystackPay(MethodChannel.Result result) {
          /*result.success("Android " + Build.VERSION.SDK);
            Toast.makeText(activity, "Its working shaaa", Toast.LENGTH_SHORT).show();*/

        if (!methodCall.hasArgument("PAYSTACK_PUBLIC_KEY")) {
            result.error("PAYSTACK ERROR", "Paystack needs your public key", null);
            return;
        }

        if (!methodCall.hasArgument("BACKEND_URL")) {
            result.error("PAYSTACK ERROR", "Paystack needs your backend url", null);
            return;
        }

        if (!methodCall.hasArgument("NAME")) {
            result.error("PAYSTACK ERROR", "Paystack needs your name", null);
            return;
        }

        if (!methodCall.hasArgument("EMAIL")) {
            result.error("PAYSTACK ERROR", "Paystack needs your email", null);
            return;
        }

        if (!methodCall.hasArgument("AMOUNT")) {
            result.error("PAYSTACK ERROR", "Paystack needs your amount", null);
            return;
        }

        if (!methodCall.hasArgument("CURRENCY")) {
            result.error("PAYSTACK ERROR", "Paystack needs your currency", null);
            return;
        }

        if (!methodCall.hasArgument("PAYMENT_FOR")) {
            result.error("PAYSTACK ERROR", "Paystack needs your payment for", null);
            return;
        }

        String paystack_public_key = null;
        if (methodCall.hasArgument("PAYSTACK_PUBLIC_KEY")) {
            paystack_public_key = methodCall.argument("PAYSTACK_PUBLIC_KEY").toString();
            //Toast.makeText(activity, currency, Toast.LENGTH_SHORT).show();
        }

        String backend_url = null;
        if (methodCall.hasArgument("BACKEND_URL")) {
            backend_url = methodCall.argument("BACKEND_URL").toString();
            //Toast.makeText(activity, paymentfor, Toast.LENGTH_SHORT).show();
        }

        String name = null;
        if (methodCall.hasArgument("NAME")) {
            name = methodCall.argument("NAME").toString();
            //Toast.makeText(activity, name, Toast.LENGTH_SHORT).show();
        }

        String email = null;
        if (methodCall.hasArgument("EMAIL")) {
            email = methodCall.argument("EMAIL").toString();
            //Toast.makeText(activity, email, Toast.LENGTH_SHORT).show();
        }

        String amount = null;
        if (methodCall.hasArgument("AMOUNT")) {
            amount = methodCall.argument("AMOUNT").toString();
            //Toast.makeText(activity, amount, Toast.LENGTH_SHORT).show();
        }

        String currency = null;
        if (methodCall.hasArgument("CURRENCY")) {
            currency = methodCall.argument("CURRENCY").toString();
            //Toast.makeText(activity, currency, Toast.LENGTH_SHORT).show();
        }

        String paymentfor = null;
        if (methodCall.hasArgument("PAYMENT_FOR")) {
            paymentfor = methodCall.argument("PAYMENT_FOR").toString();
            //Toast.makeText(activity, paymentfor, Toast.LENGTH_SHORT).show();
        }

        Intent intent = new Intent(context, CardEditActivity.class);
        intent.putExtra(CreditCardUtils.PAYSTACK_API, paystack_public_key);
        intent.putExtra(CreditCardUtils.BACKEND_URL, backend_url);
        intent.putExtra(EMAIL, email);
        intent.putExtra(CreditCardUtils.AMOUNT, amount);
        intent.putExtra(CreditCardUtils.CURRENCY, currency);
        intent.putExtra(CreditCardUtils.PAYMENT_FOR, paymentfor);
        intent.putExtra(CreditCardUtils.POSITION, 0);
        activity.startActivityForResult(intent, PAYSTACK_REQUEST_CODE);

    }
/*

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
       // mFacebook.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PAYSTACK_REQUEST_CODE) {
            if (data != null && resultCode == RESULT_OK) {
                pendingResult.success("SUCCESSFULL");
            } else {
                pendingResult.success("UNSUCCESSFULL PAYSTACK PAYMENT");
            }
            pendingResult = null;
            methodCall = null;
        }else {
            pendingResult.success("UNSUCCESSFULL PAYSTACK PAYMENT");
            //Toast.makeText(activity, "Back was pressed", Toast.LENGTH_SHORT).show();
        }
    }
*/



}
