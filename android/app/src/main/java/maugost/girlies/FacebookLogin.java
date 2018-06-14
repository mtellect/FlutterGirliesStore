package maugost.girlies;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import com.mukeshsolanki.sociallogin.facebook.FacebookHelper;
import com.mukeshsolanki.sociallogin.facebook.FacebookListener;
import com.mukeshsolanki.sociallogin.google.GoogleHelper;
import com.mukeshsolanki.sociallogin.google.GoogleListener;
import com.mukeshsolanki.sociallogin.instagram.InstagramHelper;
import com.mukeshsolanki.sociallogin.instagram.InstagramListener;
import com.mukeshsolanki.sociallogin.twitter.TwitterHelper;
import com.mukeshsolanki.sociallogin.twitter.TwitterListener;
import java.util.Locale;

public class FacebookLogin extends AppCompatActivity
    implements FacebookListener, TwitterListener, GoogleListener, InstagramListener,
    View.OnClickListener {

  private Button mFacebookButton, mTwitterButton, mGoogleButton, mInstagramButton;
  private TextView mDataTextView;
  private FacebookHelper mFacebook;
  private TwitterHelper mTwitter;
  private GoogleHelper mGoogle;
  private InstagramHelper mInstagram;

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_fb_login);
    FacebookSdk.setApplicationId(getResources().getString(R.string.facebook_app_id));
    FacebookSdk.sdkInitialize(this);
    AppEventsLogger.activateApp(this);
    mFacebook = new FacebookHelper(this);
    initialize();
  }

  private void initialize() {
    mFacebookButton = (Button) findViewById(R.id.facebook_button);
    mGoogleButton = (Button) findViewById(R.id.google_button);
    mTwitterButton = (Button) findViewById(R.id.twitter_button);
    mInstagramButton = (Button) findViewById(R.id.instagram_button);
    mDataTextView = (TextView) findViewById(R.id.data_received_text_view);

    mFacebookButton.setOnClickListener(this);
    mGoogleButton.setOnClickListener(this);
    mTwitterButton.setOnClickListener(this);
    mInstagramButton.setOnClickListener(this);

    mFacebook = new FacebookHelper(this);
    //mTwitter = new TwitterHelper(this, this, "Your Twitter Api Key", "Your Twitter Api Secret");
    mGoogle = new GoogleHelper(this, this, null);
    mInstagram = new InstagramHelper(this, this, "Your Client Id", "Your Client Secret", "Your call back url");
  }

  @Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    mFacebook.onActivityResult(requestCode, resultCode, data);
    //mTwitter.onActivityResult(requestCode, resultCode, data);
    mGoogle.onActivityResult(requestCode, resultCode, data);
  }

  @Override public void onTwitterError(String errorMessage) {
  }

  @Override public void onTwitterSignIn(String authToken, String secret, long userId) {
    mDataTextView.setText(
        String.format(Locale.US, "User id:%d\n\nAuthToken:%s\n\nAuthSecret:%s", userId, authToken,
            secret));
  }

  @Override public void onFbSignInFail(String errorMessage) {
    mDataTextView.setText(errorMessage);
  }

  @Override public void onFbSignInSuccess(String authToken, String userId) {
    mDataTextView.setText(
        String.format(Locale.US, "User id:%s\n\nAuthToken:%s", userId, authToken));
  }

  @Override public void onFBSignOut() {
    mDataTextView.setText("Signed out of Facebook");
  }

  @Override public void onGoogleAuthSignIn(String authToken, String userId) {
    mDataTextView.setText(
        String.format(Locale.US, "User id:%s\n\nAuthToken:%s", userId, authToken));
  }

  @Override public void onGoogleAuthSignInFailed(String errorMessage) {
    mDataTextView.setText(errorMessage);
  }

  @Override public void onGoogleAuthSignOut() {
    mDataTextView.setText("Signed out of google");
  }

  @Override public void onClick(View v) {
    switch (v.getId()) {
      case R.id.facebook_button:
        mFacebook.performSignIn(this);
        break;
      case R.id.twitter_button:
        mTwitter.performSignIn(this);
        break;
      case R.id.google_button:
        mGoogle.performSignIn(this);
        break;
      case R.id.instagram_button:
        mInstagram.performSignIn();
        break;
    }
  }

  @Override public void onInstagramSignInFail(String errorMessage) {
    mDataTextView.setText(errorMessage);
  }

  @Override public void onInstagramSignInSuccess(String authToken, String userId) {
    mDataTextView.setText(
        String.format(Locale.US, "User id:%s\n\nAuthToken:%s", userId, authToken));
  }
}
