package com.samsung.msf2.quizapp;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.samsung.multiscreen.Application;
import com.samsung.multiscreen.Channel;
import com.samsung.multiscreen.Client;
import com.samsung.multiscreen.Message;
import com.samsung.multiscreen.Result;
import com.samsung.multiscreen.Service;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class PlayClientCatActivity extends Activity
{

    private String whichPlayer;
    private final String LOG="PlayClientCatActivity.java";
    public static Application application = null;
    public Service service;
    private Map<String, String> attribute = new ConcurrentHashMap();

    FragmentManager fragmentManager;
    FragmentTransaction fragmentTransaction;

    QuestionScrenFragment questionScreenFrag = null;
    ScoreScreenFragment scoreScreenFrag = null;
    MultiPlayerScreenFragment multiPlayerFrag = null;

    private String connectedTVName;
    private String userName;
    private ProgressBar spinner;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_play_client_cat);

        Intent intent = this.getIntent();
        whichPlayer = intent.getStringExtra("selectPlayer");
        connectedTVName =  intent.getStringExtra("connectedTVName");
        userName = intent.getStringExtra("userName");

        spinner = (ProgressBar)findViewById(R.id.progressBar1);
        spinner.setVisibility(View.VISIBLE);

        initializeAppAPI();

     /*   if(whichPlayer.equals("SinglePlayer"))
        {
            initializeAppAPI();
        }
        else if(whichPlayer.equals("MultiPlayer"))
        {
            initializeAppAPI();
        }
        */
    }

    public String getUserName()
    {
        return userName;
    }

    public String getConnectedTVName()
    {
        return connectedTVName;
    }

    public void launchCategoryFromMultiPlayer(String clientID)
    {
        fragmentManager = getFragmentManager();
        fragmentTransaction = fragmentManager.beginTransaction();

        Bundle args = new Bundle();
        args.putString("selectPlayer", "MultiPlayer");
        args.putString("clientID", clientID);

        SelectPlayCategoryFragment selectPlayerFrag = new SelectPlayCategoryFragment();
        fragmentTransaction.replace(R.id.fragment_container, selectPlayerFrag);
      //  fragmentTransaction.addToBackStack("selectPlayer");
        selectPlayerFrag.setArguments(args);
        fragmentTransaction.commit();
    }

    public void launchWaitScreenFrag()
    {
        fragmentManager = getFragmentManager();
        fragmentTransaction = fragmentManager.beginTransaction();

        WaitScreenFragment waitFrag = new WaitScreenFragment();
        fragmentTransaction.replace(R.id.fragment_container, waitFrag);
        fragmentTransaction.commit();
    }

    public void initializeAppAPI()
    {
        attribute.put("name", "" + App.str_deviceName);
      //  Log.v(LOG,App.str_deviceName);
        service = App.getInstance().service;
        application = service.createApplication(Uri.parse("quizApp"), "com.samsung.multiscreen.quizApp");

        application.addOnMessageListener("say", new Channel.OnMessageListener() {

            @Override
            public void onMessage(Message message) {

                Log.v("test", message.getData().toString());

                JSONObject mainObject = null;

                String connectionStateStr = null;
                String responseStr = null;

                String questionStr = null;
                String option1Str = null;
                String option2Str = null;
                String option3Str = null;
                String option4Str = null;

                String selectedAnswer = null;
                String scoreStr = null;

                String playerType = null;
                String clientName = null;
                String multiPlayer = null;
                String disconnect = null;
                String session = null;
                String connectionState = null;
                String questionNo = null;

                try {
                    mainObject = new JSONObject(message.getData().toString());
                } catch (JSONException e) {
                    //  e.printStackTrace();
                }

                try {
                    connectionStateStr = mainObject.getString("connectionState");
                } catch (JSONException e) {
                    //  e.printStackTrace();
                }

                try {
                    responseStr = mainObject.getString("response");
                } catch (JSONException e) {
                    //   e.printStackTrace();
                }

                try {
                    playerType = mainObject.getString("playerType");
                    clientName = mainObject.getString("clientName");

                } catch (JSONException e) {
                    //   e.printStackTrace();
                }

                try {
                    multiPlayer = mainObject.getString("multiPlayer");
                } catch (JSONException e) {
                    //   e.printStackTrace();
                }

                try {
                    questionStr = mainObject.getString("question");
                    option1Str = mainObject.getString("option1");
                    option2Str = mainObject.getString("option2");
                    option3Str = mainObject.getString("option3");
                    option4Str = mainObject.getString("option4");
                    questionNo = mainObject.getString("questionNo");
                } catch (JSONException e) {
                    //  e.printStackTrace();
                }

                try {
                    scoreStr = mainObject.getString("Score");
                } catch (JSONException e) {
                    //   e.printStackTrace();
                }

                if (connectionStateStr != null) {

                    if (connectionStateStr.equals("buzy")) {
                        Toast.makeText(PlayClientCatActivity.this, "Host Busy!! Please try again later...", Toast.LENGTH_LONG).show();

                        onBackPressed();
                    } else if (connectionStateStr.equals("available")) {

                        if (whichPlayer.equals("SinglePlayer")) {

                            fragmentManager = getFragmentManager();
                            fragmentTransaction = fragmentManager.beginTransaction();

                            Bundle args = new Bundle();
                            args.putString("selectPlayer", "SinglePlayer");
                            args.putString("clientID", "null");

                            SelectPlayCategoryFragment selectPlayerFrag = new SelectPlayCategoryFragment();
                            fragmentTransaction.add(R.id.fragment_container, selectPlayerFrag, "selectPlayerFrag");
                            // fragmentTransaction.addToBackStack("selectPlayer");
                            selectPlayerFrag.setArguments(args);
                            fragmentTransaction.commit();

                        } else if(whichPlayer.equals("MultiPlayer")){
                            fragmentManager = getFragmentManager();
                            fragmentTransaction = fragmentManager.beginTransaction();
                            ClientListFragment clientListFrag = new ClientListFragment();

                            Bundle args = new Bundle();
                            args.putString("userName", userName);
                            args.putString("connectedTVName", connectedTVName);
                            clientListFrag.setArguments(args);

                            fragmentTransaction.add(R.id.fragment_container, clientListFrag, "clientListFrag");
                            // fragmentTransaction.addToBackStack("selectPlayer");
                            fragmentTransaction.commit();
                        }
                    }
                } else if (responseStr != null) {

                    if (questionScreenFrag != null) {
                        selectedAnswer = questionScreenFrag.getSelectedAnswer();

                        JSONObject jsonObj = null;
                        try {
                            jsonObj = new JSONObject();
                            jsonObj.put("answer", selectedAnswer);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        String messageSend = jsonObj.toString();
                        Log.v(App.TAG, messageSend);
                        PlayClientCatActivity.application.publish("say", messageSend, Message.TARGET_HOST);
                    }

                } else if (questionStr != null) {

                    Log.v("test", questionStr);

                    if (questionScreenFrag == null) {
                        questionScreenFrag = new QuestionScrenFragment();
                        fragmentTransaction = fragmentManager.beginTransaction();
                        questionScreenFrag.updateQuestionText(questionStr, option1Str, option2Str, option3Str, option4Str, questionNo);

                        fragmentTransaction.replace(R.id.fragment_container, questionScreenFrag);
                        //   fragmentTransaction.addToBackStack("questionScreen");
                        //  fragmentTransaction.add(R.id.fragment_container, questionScreenFrag, "questionScreenFrag");

                        fragmentTransaction.commit();
                    } else {
                        questionScreenFrag.updateQuestionText(questionStr, option1Str, option2Str, option3Str, option4Str, questionNo);
                        questionScreenFrag.resetSelectedAnswer();
                    }

                } else if (scoreStr != null) {

                    if (scoreScreenFrag == null) {
                        scoreScreenFrag = new ScoreScreenFragment();
                        fragmentTransaction = fragmentManager.beginTransaction();
                        scoreScreenFrag.updateScoreText(scoreStr);
                        fragmentTransaction.replace(R.id.fragment_container, scoreScreenFrag);
                        //   fragmentTransaction.addToBackStack("scoreScreen");

                        fragmentTransaction.commit();
                    } else {
                        scoreScreenFrag.updateScoreText(scoreStr);
                    }
                } else if (multiPlayer != null) {
                    if (multiPlayer.equals("yes")) {
                        Log.v("test", "multi player yes");
                    }
                } else if (playerType != null) {
                    if (playerType.equals("MultiPlayer")) {
                        if (multiPlayerFrag == null) {
                            multiPlayerFrag = new MultiPlayerScreenFragment();
                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.fragment_container, multiPlayerFrag);
                            fragmentTransaction.commit();
                        }
                    }
                }


            }
        });

        application.setOnReadyListener(new Channel.OnReadyListener()
        {
            @Override
            public void onReady()
            {
            //    Log.d(LOG, "application onReady()");
             //   application.publish("say", whichPlayer, Message.TARGET_HOST);
            }
        });

        application.setOnDisconnectListener(new Channel.OnDisconnectListener() {
            @Override
            public void onDisconnect(Client client) {

                //   Log.d(LOG, "application.onDisconnect()"+client.getId());
                application.disconnect();

            }
        });

        application.connect(attribute, new Result<Client>() {
            @Override
            public void onSuccess(Client client) {
                JSONObject jsonObj = null;

                spinner.setVisibility(View.GONE);
                if (whichPlayer.equals("SinglePlayer")) {
                    try {
                        jsonObj = new JSONObject();
                        jsonObj.put("playerType", "singlePlayer");
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    String messageSend = jsonObj.toString();
                    Log.v(App.TAG, messageSend);
                    application.publish("say", messageSend, Message.TARGET_HOST);
                } else if (whichPlayer.equals("MultiPlayer")) {

                    try {
                        jsonObj = new JSONObject();
                        jsonObj.put("playerType", "MultiPlayer");
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    String messageSend = jsonObj.toString();
                    Log.v(App.TAG, messageSend);
                    application.publish("say", messageSend, Message.TARGET_HOST);

                }
            }

            @Override
            public void onError(com.samsung.multiscreen.Error error) {
                Log.v(App.TAG, error.toString());
                Toast.makeText(PlayClientCatActivity.this, "Please Re-start application!!!!", Toast.LENGTH_LONG).show();
            }
        });
    }



}
