package com.samsung.msf2.quizapp;

import android.app.Activity;
import android.app.FragmentManager;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.samsung.multiscreen.Message;

import org.json.JSONObject;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link QuestionScrenFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link QuestionScrenFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class QuestionScrenFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

  //  private OnFragmentInteractionListener mListener;

    private TextView questionNumberTextView;
    private TextView questionTextView;

    private RadioGroup radioOptionGroup;
    private RadioButton radioOption1Button;
    private RadioButton radioOption2Button;
    private RadioButton radioOption3Button;
    private RadioButton radioOption4Button;

   // private TextView option1TextView;
   // private TextView option2TextView;
   // private TextView option3TextView;
   // private TextView option4TextView;

    private String questionNumberText = "";
    private String questionText = "";
    private String option1Text = "";
    private String option2Text = "";
    private String option3Text = "";
    private String option4Text = "";

    private String selectedId = "";
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment QuestionScrenFragment.
     */
    // TODO: Rename and change types and number of parameters


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        View v = inflater.inflate(R.layout.fragment_question_scren, container, false);

        questionNumberTextView = (TextView) v.findViewById(R.id.questionnoid);

        questionTextView = (TextView) v.findViewById(R.id.questionfragid);

        radioOptionGroup = (RadioGroup) v.findViewById(R.id.optionRadioGroupId);

        radioOption1Button = (RadioButton) v.findViewById(R.id.option1FragId);
        radioOption2Button = (RadioButton) v.findViewById(R.id.option2FragId);
        radioOption3Button = (RadioButton) v.findViewById(R.id.option3FragId);
        radioOption4Button = (RadioButton) v.findViewById(R.id.option4FragId);

        radioOptionGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                // find which radio button is selected
                if(checkedId == R.id.option1FragId) {
                    Log.v("test", "option1");
                    selectedId = "1";
                } else if(checkedId == R.id.option2FragId) {
                    Log.v("test", "option2");
                    selectedId = "2";
                } else if(checkedId == R.id.option3FragId) {
                    Log.v("test", "option3");
                    selectedId = "3";
                }  else if(checkedId == R.id.option4FragId) {
                    Log.v("test", "option4");
                    selectedId = "4";
                }
            }
        });

        if(questionNumberText.length() > 0)
        {
            questionNumberTextView.setText("Question No. " + questionNumberText);
        }

        if(questionText.length() > 0) {
            questionTextView.setText(questionText);
        }

        if(option1Text.length() > 0)
        {
            radioOption1Button.setText(option1Text);
        }

        if(option2Text.length() > 0)
        {
            radioOption2Button.setText(option2Text);
        }

        if(option3Text.length() > 0)
        {
            radioOption3Button.setText(option3Text);
        }

        if(option4Text.length() > 0)
        {
            radioOption4Button.setText(option4Text);
        }

        v.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View view, int keyCode, KeyEvent keyEvent) {

                if( keyCode == KeyEvent.KEYCODE_BACK )
                {


                    // getActivity().onBackPressed();
                    FragmentManager fm = getFragmentManager();
                    fm.popBackStack("selectPlayerCateg", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    //  fm.popBackStackImmediate();

                    return true;
                }
                return true;
            }
        });

        return v;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState)
    {
        super.onActivityCreated(savedInstanceState);
    }

    public void updateQuestionText(String text, String option1, String option2, String option3, String option4, String questionNo)
    {
        questionText = text;
        option1Text = option1;
        option2Text = option2;
        option3Text = option3;
        option4Text = option4;
        questionNumberText = questionNo;

        if(questionNumberTextView != null)
        {
            questionNumberTextView.setText("Question No. " + questionNumberText);
        }

        if(questionTextView != null) {
            questionTextView.setText(questionText);
        }

        if(radioOptionGroup != null)
        {
            selectedId = "";
            radioOptionGroup.clearCheck();
        }

        if(radioOption1Button != null)
        {
            radioOption1Button.setText(option1Text);
        }

        if(radioOption2Button != null)
        {
            radioOption2Button.setText(option2Text);
        }

        if(radioOption3Button != null)
        {
            radioOption3Button.setText(option3Text);
        }

        if(radioOption4Button != null)
        {
            radioOption4Button.setText(option4Text);
        }

    }

    public String getSelectedAnswer()
    {
        return selectedId;
    }

    public void resetSelectedAnswer()
    {
        selectedId = "";
    }

    public void SetRadioGroupButton(Boolean value)
    {
        if(radioOptionGroup != null)
        {
            radioOptionGroup.setEnabled(value);
        }
    }

   /* @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }
*/
    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
   /* public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        public void onFragmentInteraction(Uri uri);
    }
*/
}
