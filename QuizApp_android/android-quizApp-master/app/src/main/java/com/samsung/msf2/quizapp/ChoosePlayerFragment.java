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

import com.samsung.multiscreen.Message;

import org.json.JSONObject;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link ChoosePlayerFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link ChoosePlayerFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class ChoosePlayerFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View v = inflater.inflate(R.layout.fragment_choose_player, container, false);

        Button singlePlayerBtn = (Button) v.findViewById(R.id.SinglePlayerId);
        Button multiPlayerBtn = (Button) v.findViewById(R.id.MultiPlayerId);

        singlePlayerBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                ChoosePlayerActivity.whichPlayer = "SinglePlayer";

                JSONObject jsonObj = null;
                try {
                    jsonObj = new JSONObject();
                    jsonObj.put("playerType", "SinglePlayer");
                } catch (Exception e) {
                    e.printStackTrace();
                }

                String messageSend = jsonObj.toString();
                Log.v(App.TAG, messageSend);
                ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);
            }
        });

        multiPlayerBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                ChoosePlayerActivity.whichPlayer = "MultiPlayer";
                JSONObject jsonObj = null;
                try {
                    jsonObj = new JSONObject();
                    jsonObj.put("playerType", "MultiPlayer");
                } catch (Exception e) {
                    e.printStackTrace();
                }

                String messageSend = jsonObj.toString();
                Log.v(App.TAG, messageSend);
                ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);
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
