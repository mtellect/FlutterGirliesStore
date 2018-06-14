package maugost.girlies.creditcarddesign.pager;
import maugost.girlies.R;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import maugost.girlies.creditcarddesign.CardEditActivity;
import maugost.girlies.creditcarddesign.CreditCardUtils;

import java.util.Calendar;

import static maugost.girlies.creditcarddesign.CreditCardUtils.*;


/**
 * Created by sharish on 9/1/15.
 */
public class CardExpiryFragment extends CreditCardFragment {



    private boolean mValidateCard = true;

    CardEditActivity cardEditActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        cardEditActivity = (CardEditActivity)getActivity();
    }


    public CardExpiryFragment() {

    }

    public View onCreateView(LayoutInflater inflater, ViewGroup group, Bundle state) {

        View v = inflater.inflate(R.layout.lyt_card_expiry, group, false);
        cardEditActivity.cardExpiryView = (EditText) v.findViewById(R.id.card_expiry);

        String expiry = "";

        Bundle args = getArguments();

        if(args != null) {

            if(args.containsKey(EXTRA_CARD_EXPIRY)) {
                expiry = getArguments().getString(EXTRA_CARD_EXPIRY);
            }

            mValidateCard = args.getBoolean(EXTRA_VALIDATE_EXPIRY_DATE, true);
        }

        if(expiry == null) {
            expiry = "";
        }

        cardEditActivity.cardExpiryView.setText(expiry);

        cardEditActivity.cardExpiryView.addTextChangedListener(this);

        return v;
    }

    @Override
    public void afterTextChanged(Editable s) {

        String text = s.toString().replace(CreditCardUtils.SLASH_SEPERATOR, "");

        String month, year="";
        if(text.length() >= 2) {
            month = text.substring(0, 2);

            if(text.length() > 2) {
                year = text.substring(2);
            }

            if(mValidateCard) {
                int mm = Integer.parseInt(month);

                if (mm <= 0 || mm >= 13) {
                    cardEditActivity.cardExpiryView.setError(getString(R.string.error_invalid_month));
                    return;
                }

                if (text.length() >= 4) {

                    int yy = Integer.parseInt(year);

                    final Calendar calendar = Calendar.getInstance();
                    int currentYear = calendar.get(Calendar.YEAR);
                    int currentMonth = calendar.get(Calendar.MONTH) + 1;

                    int millenium = (currentYear / 1000) * 1000;


                    if (yy + millenium < currentYear) {
                        cardEditActivity.cardExpiryView.setError(getString(R.string.error_card_expired));
                        return;
                    } else if (yy + millenium == currentYear && mm < currentMonth) {
                        cardEditActivity.cardExpiryView.setError(getString(R.string.error_card_expired));
                        return;
                    }
                }
            }

        }
        else {
            month = text;
        }

        int previousLength = cardEditActivity.cardExpiryView.getText().length();
        int cursorPosition = cardEditActivity.cardExpiryView.getSelectionEnd();

        text = CreditCardUtils.handleExpiration(month,year);

        cardEditActivity.cardExpiryView.removeTextChangedListener(this);
        cardEditActivity.cardExpiryView.setText(text);
        cardEditActivity.cardExpiryView.setSelection(text.length());
        cardEditActivity.cardExpiryView.addTextChangedListener(this);

        int modifiedLength = text.length();

        if(modifiedLength <= previousLength && cursorPosition < modifiedLength) {
            cardEditActivity.cardExpiryView.setSelection(cursorPosition);
        }

        onEdit(text);

        if(text.length() == 5) {
            onComplete();
        }

    }


    @Override
    public void focus() {

        if(isAdded()) {
            cardEditActivity.cardExpiryView.selectAll();
        }
    }


    public void onSaveInstanceState(Bundle outState) {

        outState.putBoolean(EXTRA_VALIDATE_EXPIRY_DATE, mValidateCard);
        super.onSaveInstanceState(outState);
    }

    public void onActivityCreated(Bundle instate) {

        if(instate != null) {
            mValidateCard = instate.getBoolean(EXTRA_VALIDATE_EXPIRY_DATE, mValidateCard);
        }

        super.onActivityCreated(instate);
    }
}
