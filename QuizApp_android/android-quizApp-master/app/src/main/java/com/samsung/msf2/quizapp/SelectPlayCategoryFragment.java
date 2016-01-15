package com.samsung.msf2.quizapp;

import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import com.samsung.multiscreen.Message;

import org.json.JSONObject;

public class SelectPlayCategoryFragment extends Fragment implements View.OnClickListener
{
    private Button btnsports,btnScienc,btnHistory;
    private String selectedCategoryforPlay;

    private String playerType;
    private String clientID;

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            View v = inflater.inflate(R.layout.fragment_select_play_category, null);

            Bundle bundle = getArguments();
            playerType = bundle.getString("selectPlayer");
            clientID = bundle.getString("clientID");

           btnHistory=(Button) v.findViewById(R.id.btn_History);
           btnScienc=(Button) v.findViewById(R.id.btn_Science);
           btnsports=(Button)v.findViewById(R.id.btn_Sports);

           // v.setOnClickListener(this);

           /* v.setOnKeyListener(new View.OnKeyListener() {
                @Override
                public boolean onKey(View view, int keyCode, KeyEvent keyEvent) {

                    if( keyCode == KeyEvent.KEYCODE_BACK )
                    {


                        return true;
                    }
                    return true;
                }
            });*/

          return v;
        }

    @Override
    public void onActivityCreated(Bundle savedInstanceState)
    {
        super.onActivityCreated(savedInstanceState);

        initializeListner();
    }


    @Override
    public void onClick(View v)
    {
        if(v.equals(btnsports))
        {
            selectedCategoryforPlay="Sports";
            Toast.makeText(getActivity(), "Sports!!!!", Toast.LENGTH_LONG).show();

            JSONObject jsonObj = null;
            try
            {
                jsonObj = new JSONObject();
                jsonObj.put("categoryType", "sports");
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }

            String messageSend = jsonObj.toString();
            Log.v(App.TAG, messageSend);
            ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

            if(playerType.equals("MultiPlayer"))
            {
                ((ChoosePlayerActivity)getActivity()).launchWaitScreenFrag();
            }

           // ChoosePlayerActivity.application.publish("say", selectedCategoryforPlay, Message.TARGET_HOST);
           // ChoosePlayerActivity.application.disconnect();
        }

        else if(v.equals(btnScienc))
        {
            selectedCategoryforPlay="Science";
            Toast.makeText(getActivity(), "Science!!!!", Toast.LENGTH_LONG).show();
            JSONObject jsonObj = null;
            try
            {
                jsonObj = new JSONObject();
                jsonObj.put("categoryType", "science");
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }

            String messageSend = jsonObj.toString();
            Log.v(App.TAG, messageSend);
            ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

            if(playerType.equals("MultiPlayer"))
            {
                ((ChoosePlayerActivity)getActivity()).launchWaitScreenFrag();
            }
        }

        else if(v.equals(btnHistory))
        {
            selectedCategoryforPlay="History";
            Toast.makeText(getActivity(), "History!!!!", Toast.LENGTH_LONG).show();

            JSONObject jsonObj = null;
            try
            {
                jsonObj = new JSONObject();
                jsonObj.put("categoryType", "history");
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }

            String messageSend = jsonObj.toString();
            Log.v(App.TAG, messageSend);
            ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

            if(playerType.equals("MultiPlayer"))
            {
                ((ChoosePlayerActivity)getActivity()).launchWaitScreenFrag();
            }
        }
    }

    public void initializeListner()
    {
        btnsports.setOnClickListener(this);
        btnScienc.setOnClickListener(this);
        btnHistory.setOnClickListener(this);
    }


}
