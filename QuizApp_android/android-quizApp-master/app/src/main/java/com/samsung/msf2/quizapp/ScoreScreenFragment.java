package com.samsung.msf2.quizapp;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.samsung.multiscreen.Application;
import com.samsung.multiscreen.Message;
import com.samsung.multiscreen.Service;

import org.json.JSONObject;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link ScoreScreenFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link ScoreScreenFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class ScoreScreenFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private TextView scoreTextView;
    private String scoreText = "";

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment ScoreScreenFragment.
     */

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        View v = inflater.inflate(R.layout.fragment_score_screen, container, false);

        scoreTextView = (TextView) v.findViewById(R.id.scoreValueId);
        scoreTextView.setText(scoreText);

        Button playAgainButton = (Button) v.findViewById(R.id.playAgainId);
        Button doneButton = (Button) v.findViewById(R.id.doneId);

        playAgainButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {


                JSONObject jsonObj = null;
                try {
                    jsonObj = new JSONObject();
                    jsonObj.put("playAgain", "playAgain");
                } catch (Exception e) {
                    e.printStackTrace();
                }

                String messageSend = jsonObj.toString();
                Log.v(App.TAG, messageSend);

                ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

               // getActivity().onBackPressed();
                FragmentManager fm = getFragmentManager();
                fm.popBackStack("selectPlayer", 0);
                //fm.popBackStack("selectPlayerCateg", FragmentManager.POP_BACK_STACK_INCLUSIVE);

                // Perform action on click
              //  FragmentManager fm = getFragmentManager();
               // fm.popBackStack("questionScreen", FragmentManager.POP_BACK_STACK_INCLUSIVE);
             //   fm.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
            }
        });

        doneButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                //  Service service = App.getInstance().service;
                //  Application application = service.createApplication(Uri.parse("quizApp"), "com.samsung.multiscreen.quizApp");
                //  application.disconnect();

                JSONObject jsonObj = null;
                try {
                    jsonObj = new JSONObject();
                    jsonObj.put("finish", "Done");
                } catch (Exception e) {
                    e.printStackTrace();
                }

                String messageSend = jsonObj.toString();
                Log.v(App.TAG, messageSend);

                ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);
                ChoosePlayerActivity.application.disconnect();

                Intent intent = new Intent(getActivity(), ThankyouActivity.class);
                startActivity(intent);
            }
        });

        return v;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState)
    {
        super.onActivityCreated(savedInstanceState);
    }

    public void updateScoreText(String text)
    {
        scoreText = text;

        if(scoreTextView != null) {
            scoreTextView.setText(text);
        }
    }

/*    public void onClick(View v)
    {
        switch (v.getId())
        {
            case R.id.playAgainId:
              //  userCheck();
                Log.v("test", "playAgainId");

                FragmentManager fm = getFragmentManager();
                fm.popBackStack();

                break;
            case  R.id.doneId:
                Log.v("test", "doneId");

                FragmentManager fm1 = getFragmentManager();
                fm1.popBackStack();

                break;

        }
    }
    */
}
