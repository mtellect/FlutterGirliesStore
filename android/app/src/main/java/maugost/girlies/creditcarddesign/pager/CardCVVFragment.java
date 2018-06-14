package maugost.girlies.creditcarddesign.pager;
import maugost.girlies.R;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.text.InputFilter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import maugost.girlies.creditcarddesign.CardEditActivity;
import maugost.girlies.creditcarddesign.CardSelector;

import static maugost.girlies.creditcarddesign.CreditCardUtils.EXTRA_CARD_CVV;


/**
 * Created by sharish on 9/1/15.
 */
public class CardCVVFragment extends CreditCardFragment {


    private int mMaxCVV = CardSelector.CVV_LENGHT_DEFAULT;

    CardEditActivity cardEditActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        cardEditActivity = (CardEditActivity)getActivity();
    }


    public CardCVVFragment() {
    }

    public View onCreateView(LayoutInflater inflater, ViewGroup group, Bundle state) {
        View v = inflater.inflate(R.layout.lyt_card_cvv, group, false);
        cardEditActivity.mCardCVVView = (EditText) v.findViewById(R.id.card_cvv);

        String cvv = null;
        if (getArguments() != null && getArguments().containsKey(EXTRA_CARD_CVV)) {
            cvv = getArguments().getString(EXTRA_CARD_CVV);
        }

        if (cvv == null) {
            cvv = "";
        }

        cardEditActivity.mCardCVVView.setText(cvv);
        cardEditActivity.mCardCVVView.addTextChangedListener(this);

        return v;
    }

    @Override
    public void afterTextChanged(Editable s) {
        onEdit(s.toString());
        if (s.length() == mMaxCVV) {
            cardEditActivity.setKeyboardVisibility(false);
            cardEditActivity.proceed_but.setVisibility(View.VISIBLE);
            //onComplete();
        }else{
            cardEditActivity.proceed_but.setVisibility(View.GONE);
        }
    }

    @Override
    public void focus() {
        if (isAdded()) {
            cardEditActivity.mCardCVVView.selectAll();
        }
    }

    public void setMaxCVV(int maxCVVLength) {
        if (cardEditActivity.mCardCVVView != null && (cardEditActivity.mCardCVVView.getText().toString().length() > maxCVVLength)) {
            cardEditActivity.mCardCVVView.setText(cardEditActivity.mCardCVVView.getText().toString().substring(0, maxCVVLength));
        }

        InputFilter[] FilterArray = new InputFilter[1];
        FilterArray[0] = new InputFilter.LengthFilter(maxCVVLength);
        cardEditActivity.mCardCVVView.setFilters(FilterArray);
        mMaxCVV = maxCVVLength;
        String hintCVV = "";
        for (int i = 0; i < maxCVVLength; i++) {
            hintCVV += "X";
        }
        cardEditActivity.mCardCVVView.setHint(hintCVV);
    }
}
