package maugost.girlies.creditcarddesign.pager;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import maugost.girlies.R;
import maugost.girlies.creditcarddesign.CardEditActivity;
import maugost.girlies.creditcarddesign.CreditCardUtils;

import static maugost.girlies.creditcarddesign.CreditCardUtils.*;

/**
 * Created by sharish on 9/1/15.
 */
public class CardNumberFragment extends CreditCardFragment {

    CardEditActivity cardEditActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        cardEditActivity = (CardEditActivity)getActivity();
    }

    public CardNumberFragment() {
    }

    public View onCreateView(LayoutInflater inflater, ViewGroup group, Bundle state) {
        View v = inflater.inflate(R.layout.lyt_card_number, group, false);
        cardEditActivity.mCardNumberView = (EditText) v.findViewById(R.id.card_number_field);

        String number = "";

        if (getArguments() != null && getArguments().containsKey(EXTRA_CARD_NUMBER)) {
            number = getArguments().getString(EXTRA_CARD_NUMBER);
        }

        if (number == null) {
            number = "";
        }

        cardEditActivity.mCardNumberView.setText(number);
        cardEditActivity.mCardNumberView.addTextChangedListener(this);

        return v;
    }


    @Override
    public void afterTextChanged(Editable s) {
        int cursorPosition = cardEditActivity.mCardNumberView.getSelectionEnd();
        int previousLength = cardEditActivity.mCardNumberView.getText().length();

        String cardNumber = CreditCardUtils.handleCardNumber(s.toString());
        int modifiedLength = cardNumber.length();

        cardEditActivity.mCardNumberView.removeTextChangedListener(this);
        cardEditActivity.mCardNumberView.setText(cardNumber);
        String rawCardNumber = cardNumber.replace(CreditCardUtils.SPACE_SEPERATOR, "");
        CreditCardUtils.CardType cardType = CreditCardUtils.selectCardType(rawCardNumber);
        int maxLengthWithSpaces = ((cardType == CreditCardUtils.CardType.AMEX_CARD) ? CARD_NUMBER_FORMAT_AMEX : CARD_NUMBER_FORMAT).length();
        cardEditActivity.mCardNumberView.setSelection(cardNumber.length() > maxLengthWithSpaces ? maxLengthWithSpaces : cardNumber.length());
        cardEditActivity.mCardNumberView.addTextChangedListener(this);

        if (modifiedLength <= previousLength && cursorPosition < modifiedLength) {
            cardEditActivity.mCardNumberView.setSelection(cursorPosition);
        }

        onEdit(cardNumber);

        if (rawCardNumber.length() == CreditCardUtils.selectCardLength(cardType)) {
            onComplete();
        }
    }

    @Override
    public void focus() {
        if (isAdded()) {
            cardEditActivity.mCardNumberView.selectAll();
        }
    }
}
