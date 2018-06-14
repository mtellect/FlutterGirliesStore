package maugost.girlies.creditcarddesign;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Calendar;

import co.paystack.android.Paystack;
import co.paystack.android.PaystackSdk;
import co.paystack.android.Transaction;
import co.paystack.android.exceptions.ExpiredAccessCodeException;
import co.paystack.android.model.Card;
import co.paystack.android.model.Charge;
import maugost.girlies.R;
import maugost.girlies.creditcarddesign.pager.CardFragmentAdapter;

import static maugost.girlies.creditcarddesign.CreditCardUtils.*;


public class CardEditActivity extends AppCompatActivity {


    public EditText mCardNumberView;
    public EditText mCardCVVView;
    public EditText cardExpiryView;
    public EditText mCardNameView;
    public View proceed_but;
    public long backClick = 0;
    int mLastPageSelected = 0;
    String backend_url ;
    String paystack_public_key ;
    View loading_layout;
    View prev_card;
    TextView proceed_price_tv;
    private CreditCardView mCreditCardView;
    private int amount;
    private int position;
    private String email;
    private String mPaymentFor;
    private String currency;
    private String mCardNumber;
    private String mCVV;
    private String mCardHolderName;
    private String mExpiry;
    private int mStartPage = 0;
    private CardFragmentAdapter mCardAdapter;
    private Transaction transaction;
    private Charge charge;

    public CardEditActivity() {
    }

//    public void setUpPaystackAPI(String paystack_public_key, String backend_url) {
//        this.paystack_public_key = paystack_public_key;
//        this.backend_url = backend_url;
//    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_card_edit);


        proceed_but = findViewById(R.id.proceed_but);
        prev_card = findViewById(R.id.prev_card);
        proceed_price_tv = findViewById(R.id.proceed_price_tv);

        prev_card.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showPrevious();
            }
        });
        proceed_but.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onDoneTapped();
            }
        });


        findViewById(R.id.next).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                ViewPager pager = (ViewPager) findViewById(R.id.card_field_container_pager);

                int current = pager.getCurrentItem();
                if (current == 0) {
                    if (mCardNumberView.getText().toString().length() < 19) {
                        mCardNumberView.setError("Enter your card number");
                        mCardNumberView.requestFocus();
                        return;
                    }
                }
                if (current == 1) {
                    if (cardExpiryView.getText().toString().length() < 5) {
                        cardExpiryView.setError("Enter your card expiry date");
                        cardExpiryView.requestFocus();
                        return;
                    }
                }
                if (current == 3) {
                    if (mCardCVVView.getText().toString().length() < 3) {
                        mCardCVVView.setError("Enter your card cvv");
                        mCardCVVView.requestFocus();
                        return;
                    }
                }
                if (current == 2) {
                    if (mCardNameView.getText().toString().isEmpty()) {
                        mCardNameView.setError("Enter your card name");
                        mCardNameView.requestFocus();
                        return;
                    }
                }

                int max = pager.getAdapter().getCount();

                if (pager.getCurrentItem() == max - 1) {
                    // if last card.
                    //onDoneTapped();
                    setKeyboardVisibility(false);
                } else {
                    showNext();
                }
            }
        });
        findViewById(R.id.previous).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showPrevious();
            }
        });

        loading_layout = findViewById(R.id.loading);

        setKeyboardVisibility(true);
        mCreditCardView = (CreditCardView) findViewById(R.id.credit_card_view);
        Bundle args = savedInstanceState != null ? savedInstanceState : getIntent().getExtras();

        loadPager(args);
        checkParams(args);
    }

    private void checkParams(Bundle bundle) {
        if (bundle == null) {
            return;
        }
        email = bundle.getString(EMAIL);
        mPaymentFor = bundle.getString(PAYMENT_FOR);
        mCardHolderName = bundle.getString(EXTRA_CARD_HOLDER_NAME);
        mCVV = bundle.getString(EXTRA_CARD_CVV);
        mExpiry = bundle.getString(EXTRA_CARD_EXPIRY);
        mCardNumber = bundle.getString(EXTRA_CARD_NUMBER);
        mStartPage = bundle.getInt(EXTRA_ENTRY_START_PAGE);
        amount = /*bundle.getInt(AMOUNT)*/Integer.parseInt(bundle.getString(AMOUNT));
        position = bundle.getInt(POSITION);
        currency = bundle.getString(CURRENCY);
        //String amtt = bundle.getString(AMOUNT);
        paystack_public_key = bundle.getString(PAYSTACK_API);
        backend_url = bundle.getString(BACKEND_URL);

        PaystackSdk.setPublicKey(paystack_public_key);
        PaystackSdk.initialize(getApplicationContext());


        String text = String.format("Securely Pay (%s %s)", amount, currency);
        proceed_price_tv.setText(text);


        final int maxCvvLength = CardSelector.selectCard(mCardNumber).getCvvLength();
        if (mCVV != null && mCVV.length() > maxCvvLength) {
            mCVV = mCVV.substring(0, maxCvvLength);
        }

        mCreditCardView.setCVV(mCVV);
        mCreditCardView.setCardHolderName(mCardHolderName);
        mCreditCardView.setCardExpiry(mExpiry);
        mCreditCardView.setCardNumber(mCardNumber);

        if (mCardAdapter != null) {
            mCreditCardView.post(new Runnable() {
                @Override
                public void run() {
                    mCardAdapter.setMaxCVV(maxCvvLength);
                    mCardAdapter.notifyDataSetChanged();
                }
            });
        }

        int cardSide = bundle.getInt(CreditCardUtils.EXTRA_CARD_SHOW_CARD_SIDE, CreditCardUtils.CARD_SIDE_FRONT);
        if (cardSide == CreditCardUtils.CARD_SIDE_BACK) {
            mCreditCardView.showBack();
        }
        if (mStartPage > 0 && mStartPage <= CARD_CVV_PAGE) {
            getViewPager().setCurrentItem(mStartPage);
        }
    }

    public void refreshNextButton() {
        ViewPager pager = (ViewPager) findViewById(R.id.card_field_container_pager);

        int max = pager.getAdapter().getCount();

        ((TextView) findViewById(R.id.next)).setText("NEXT");

        if (pager.getCurrentItem() == max - 1) {
            //String text = String.format("PAY (%s %s)",currency,amount);
            ((TextView) findViewById(R.id.next)).setText("DONE");
        }


    }

    ViewPager getViewPager() {
        return (ViewPager) findViewById(R.id.card_field_container_pager);
    }

    public void loadPager(Bundle bundle) {
        final ViewPager pager = getViewPager();
        pager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {

                /*if(position!=0){
                    prev_card.setVisibility(View.VISIBLE);
                }else{
                    prev_card.setVisibility(View.GONE);
                }*/

                mCardAdapter.focus(position);

                if ((mCreditCardView.getCardType() != CreditCardUtils.CardType.AMEX_CARD) && (position == 3)) {
                    mCreditCardView.showBack();
                } else if (((position == 1) || (position == 2)) /*&& (mLastPageSelected == 2)*/ && (mCreditCardView.getCardType() != CreditCardUtils.CardType.AMEX_CARD)) {
                    mCreditCardView.showFront();
                }

                mLastPageSelected = position;

                refreshNextButton();

            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
        pager.setOffscreenPageLimit(4);

        mCardAdapter = new CardFragmentAdapter(getSupportFragmentManager(), bundle);
        mCardAdapter.setOnCardEntryCompleteListener(new CardFragmentAdapter.ICardEntryCompleteListener() {
            @Override
            public void onCardEntryComplete(int currentIndex) {
                showNext();
            }

            @Override
            public void onCardEntryEdit(int currentIndex, String entryValue) {
                switch (currentIndex) {
                    case 0:
                        mCardNumber = entryValue.replace(CreditCardUtils.SPACE_SEPERATOR, "");
                        mCreditCardView.setCardNumber(mCardNumber);
                        if (mCardAdapter != null) {
                            mCardAdapter.setMaxCVV(CardSelector.selectCard(mCardNumber).getCvvLength());
                        }
                        break;
                    case 1:
                        mExpiry = entryValue;
                        mCreditCardView.setCardExpiry(entryValue);
                        break;
                    case 3:
                        mCVV = entryValue;
                        mCreditCardView.setCVV(entryValue);
                        break;
                    case 2:
                        mCardHolderName = entryValue;
                        mCreditCardView.setCardHolderName(entryValue);
                        break;
                }
            }
        });

        pager.setAdapter(mCardAdapter);

    }

    public void onSaveInstanceState(Bundle outState) {
        outState.putString(EXTRA_CARD_CVV, mCVV);
        outState.putString(EXTRA_CARD_HOLDER_NAME, mCardHolderName);
        outState.putString(EXTRA_CARD_EXPIRY, mExpiry);
        outState.putString(EXTRA_CARD_NUMBER, mCardNumber);

        super.onSaveInstanceState(outState);
    }

    public void onRestoreInstanceState(Bundle inState) {
        super.onRestoreInstanceState(inState);
        checkParams(inState);
    }

    public void showPrevious() {
        final ViewPager pager = (ViewPager) findViewById(R.id.card_field_container_pager);
        int currentIndex = pager.getCurrentItem();

        if (currentIndex == 0) {
            setResult(RESULT_CANCELED);
            finish();
        }

        if (currentIndex - 1 >= 0) {
            pager.setCurrentItem(currentIndex - 1);
        }

        refreshNextButton();
    }

    public void showNext() {
        final ViewPager pager = (ViewPager) findViewById(R.id.card_field_container_pager);
        CardFragmentAdapter adapter = (CardFragmentAdapter) pager.getAdapter();

        int max = adapter.getCount();
        int currentIndex = pager.getCurrentItem();

        if (currentIndex + 1 < max) {

            pager.setCurrentItem(currentIndex + 1);
        } else {
            // completed the card entry.
            setKeyboardVisibility(false);
        }

        refreshNextButton();
    }

    private void onDoneTapped() {
        setKeyboardVisibility(false);
        try {
            startAFreshCharge(true);
        } catch (Exception e) {
            e.printStackTrace();
            loading_layout.setVisibility(View.GONE);
            setKeyboardVisibility(true);
            Toast("Unexpected Error Occurred :" + e.getMessage());
        }
    }

    public void clickBack(View v) {
        onBackPressed();
        setKeyboardVisibility(false);

    }

    // from the link above
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

        // Checks whether a hardware keyboard is available
        if (newConfig.hardKeyboardHidden == Configuration.HARDKEYBOARDHIDDEN_NO) {

            RelativeLayout parent = (RelativeLayout) findViewById(R.id.parent);
            RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) parent.getLayoutParams();
            layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT, 0);
            parent.setLayoutParams(layoutParams);

        }
    }

    public void setKeyboardVisibility(boolean visible) {
        final EditText editText = (EditText) findViewById(R.id.card_number_field);

        if (!visible) {

            InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
        } else {
            getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        }
    }

    private Card loadCardFromForm() {
        //validate fields
        Card card;
        card = new Card.Builder(mCardNumber, 0, 0, mCVV).build();

        String YYYY = "20" + mExpiry.substring(3, 5);

        String MM = mExpiry.substring(0, 2);

        int month = Integer.parseInt(MM);

        card.setExpiryMonth(month);

        int year = Integer.parseInt(YYYY);

        card.setExpiryYear(year);

        return card;
    }

    private void Toast(String s) {
        Toast.makeText(this, s, Toast.LENGTH_SHORT).show();
    }

    private void startAFreshCharge(boolean local) throws Exception {
        // initialize the charge
        charge = new Charge();

        charge.setCard(loadCardFromForm());

        Toast("Performing transaction... please wait");
        loading_layout.setVisibility(View.VISIBLE);
        setKeyboardVisibility(false);

        int amt = currency.equals("NGN") ? amount * 100 : amount;

        charge.setCurrency(currency);
        charge.setAmount(amt);
        charge.setEmail(email);
        charge.setReference("Money Home " + email + " " + amt + " " + Calendar.getInstance().getTimeInMillis());
        charge.putCustomField("Payment for", mPaymentFor);


        if (!local) {
            new fetchAccessCodeFromServer().execute(backend_url + "/new-access-code");
            return;
        }
        chargeCard();
    }

    private void chargeCard() {
        transaction = null;
        PaystackSdk.chargeCard(this, charge, new Paystack.TransactionCallback() {
            // This is called only after transaction is successful
            @Override
            public void onSuccess(Transaction transaction) {
                Intent intent = getIntent();
                intent.putExtra(CreditCardUtils.TRANSACTION_ID, transaction.getReference());
                intent.putExtra(CreditCardUtils.POSITION, position);
                setResult(RESULT_OK, intent);
                finish();
            }

            // This is called only before requesting OTP
            // Save reference so you may send to server if
            // error occurs with OTP
            // No need to dismiss dialog
            @Override
            public void beforeValidate(Transaction transaction) {
//                MyPaystack.this.transaction = transaction;
//                Toast.makeText(MyPaystack.this, transaction.getReference(), Toast.LENGTH_LONG).show();
//                updateTextViews();
            }

            @Override
            public void onError(Throwable error, Transaction transaction) {
                // If an access code has expired, simply ask your server for a new one
                // and restart the charge instead of displaying error
                transaction = transaction;
                if (error instanceof ExpiredAccessCodeException) {
                    try {
                        startAFreshCharge(false);
                    } catch (Exception e) {
                        e.printStackTrace();
                        loading_layout.setVisibility(View.GONE);
                        Toast(error.getMessage());
                    }
                    return;
                }

                loading_layout.setVisibility(View.GONE);
                Toast(error.getMessage());
            }

        });
    }

    @Override
    public void onBackPressed() {
        long now = System.currentTimeMillis();
        long diff = now - backClick;

        if (diff < 5000 && backClick != 0) {
            Intent intent = getIntent();
            setResult(RESULT_CANCELED, intent);
            this.finish();
        } else {
            Toast("Press back again to exit");
            backClick = System.currentTimeMillis();

        }


    }

    private class verifyOnServer extends AsyncTask<String, Void, String> {
        private String reference;
        private String error;

        @Override
        protected void onPostExecute(final String result) {
            super.onPostExecute(result);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    loading_layout.setVisibility(View.GONE);

                    if (result != null) {
                        Intent intent = getIntent();
                        setResult(RESULT_OK, intent);
                        finish();
                    } else {
                        Toast("There was an error verifying");
                    }
                }
            });
        }

        @Override
        protected String doInBackground(String... reference) {
            try {
                this.reference = reference[0];
                URL url = new URL(backend_url + "/verify/" + this.reference);
                BufferedReader in = new BufferedReader(
                        new InputStreamReader(
                                url.openStream()));

                String inputLine;
                inputLine = in.readLine();
                in.close();
                return inputLine;
            } catch (Exception e) {
                error = e.getClass().getSimpleName() + ": " + e.getMessage();
            }
            return null;
        }
    }

    private class fetchAccessCodeFromServer extends AsyncTask<String, Void, String> {
        private String error;

        @Override
        protected void onPostExecute(final String result) {
            super.onPostExecute(result);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (result != null) {
                        charge.setAccessCode(result);
                        chargeCard();
                    } else {
                        Toast("There was a problem getting a new access codes");
                        loading_layout.setVisibility(View.GONE);
                    }
                }
            });

        }

        @Override
        protected String doInBackground(String... ac_url) {
            try {
                URL url = new URL(ac_url[0]);
                BufferedReader in = new BufferedReader(
                        new InputStreamReader(
                                url.openStream()));

                String inputLine;
                inputLine = in.readLine();
                in.close();
                return inputLine;
            } catch (Exception e) {
                error = e.getClass().getSimpleName() + ": " + e.getMessage();
            }
            return null;
        }
    }
}
