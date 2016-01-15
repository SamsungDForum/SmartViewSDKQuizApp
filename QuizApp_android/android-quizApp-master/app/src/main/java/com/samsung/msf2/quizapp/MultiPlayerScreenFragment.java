package com.samsung.msf2.quizapp;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.samsung.multiscreen.Message;

import org.json.JSONObject;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link MultiPlayerScreenFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link MultiPlayerScreenFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class MultiPlayerScreenFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private Button btnYes, btnNo;
    private String clientName;
    private TextView msgTextView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View v = inflater.inflate(R.layout.fragment_multi_player_screen, container, false);

        btnYes = (Button) v.findViewById(R.id.yesId);
        btnNo = (Button) v.findViewById(R.id.noId);

        msgTextView = (TextView) v.findViewById(R.id.playWithClientId);


        Bundle args = new Bundle();
        args.putString("clientName", clientName);

        Bundle bundle = getArguments();
        clientName = bundle.getString("clientName");

        msgTextView.setText("Do you want to play with client "+clientName+"?");

        btnYes.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {


                JSONObject jsonObj = null;
                try {
                    jsonObj = new JSONObject();
                    jsonObj.put("multiPlayer", "yes");
                } catch (Exception e) {
                    e.printStackTrace();
                }

                String messageSend = jsonObj.toString();
                Log.v(App.TAG, messageSend);

                ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

               // getActivity().onBackPressed();

                // Perform action on click
                //  FragmentManager fm = getFragmentManager();
                // fm.popBackStack("questionScreen", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                //   fm.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
            }
        });

        btnNo.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                JSONObject jsonObj = null;
                try {
                    jsonObj = new JSONObject();
                    jsonObj.put("multiPlayer", "no");
                } catch (Exception e) {
                    e.printStackTrace();
                }

                String messageSend = jsonObj.toString();
                Log.v(App.TAG, messageSend);

                ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

                getActivity().onBackPressed();

                // Perform action on click
                //  FragmentManager fm = getFragmentManager();
                // fm.popBackStack("questionScreen", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                //   fm.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
            }
        });

        return v;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState)
    {
        super.onActivityCreated(savedInstanceState);


    }



}
