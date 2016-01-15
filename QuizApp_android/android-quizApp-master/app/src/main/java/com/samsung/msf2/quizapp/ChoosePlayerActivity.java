package com.samsung.msf2.quizapp;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.app.ProgressDialog;
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

public class ChoosePlayerActivity extends Activity
{

    public static String whichPlayer;
    private String selectPlayer;
    private String connectedTVName;
    private String userName;

    FragmentManager fragmentManager;
    FragmentTransaction fragmentTransaction;

    public static Application application = null;
    public Service service;
    private Map<String, String> attribute = new ConcurrentHashMap();

    QuestionScrenFragment questionScreenFrag = null;
    ScoreScreenFragment scoreScreenFrag = null;
    MultiPlayerScreenFragment multiPlayerFrag = null;
    WaitScreenFragment waitScreenFrag = null;
    ClientListFragment clientListFrag = null;
    SelectPlayCategoryFragment selectPlayerCategFrag = null;

  //  private ProgressBar spinner;

    private ProgressDialog progressSpinner;

    private enum ScreenFrag
    {
        SELECTPLAYERSCREEN,
        SELECTCATEGORYSCREEN,
        QUESTIONSCREEN,
        CLIENTLISTSCREEN,
        SCORESCREEN,
        MULTIPLAYERMSGSCREEN,
        WAITSCREEN
    }
    ScreenFrag currentFrag;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_choose_player);

        Intent intent = this.getIntent();
        selectPlayer = intent.getStringExtra("selectPlayer");
        connectedTVName = intent.getStringExtra("connectedTVName");
        userName = intent.getStringExtra("userName");

      //  spinner = (ProgressBar)findViewById(R.id.progressBarId);
      //  spinner.setVisibility(View.VISIBLE);

        initializeAppAPI();

        fragmentManager = getFragmentManager();
        fragmentTransaction = fragmentManager.beginTransaction();

      //  Bundle args = new Bundle();
      //  args.putString("selectPlayer", "SinglePlayer");
      //  args.putString("clientID", "null");

        ChoosePlayerFragment choosePlayerFrag = new ChoosePlayerFragment();
        fragmentTransaction.add(R.id.fragment_container_new, choosePlayerFrag, "selectPlayer");
        fragmentTransaction.addToBackStack("selectPlayer");
     //   choosePlayerFrag.setArguments(args);
        currentFrag = ScreenFrag.SELECTPLAYERSCREEN;
        fragmentTransaction.commit();

        progressSpinner = new ProgressDialog(this);
        progressSpinner.setTitle("Connecting with TV");
        progressSpinner.setMessage("Please wait ...");
        progressSpinner.show();
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
                String sessionEnd = null;
                String changeCategory = null;

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
                    sessionEnd = mainObject.getString("session");
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


                try {
                    changeCategory = mainObject.getString("changeCategory");
                } catch (JSONException e) {
                    //   e.printStackTrace();
                }

                if (connectionStateStr != null) {

                    if (connectionStateStr.equals("buzy")) {
                        Toast.makeText(ChoosePlayerActivity.this, "Host Busy!! Please try again later...", Toast.LENGTH_LONG).show();

                       // onBackPressed();
                    } else if (connectionStateStr.equals("available")) {

                        if (whichPlayer.equals("SinglePlayer")) {

                            fragmentManager = getFragmentManager();

                            Bundle args = new Bundle();
                            args.putString("selectPlayer", "SinglePlayer");
                            args.putString("clientID", "null");

                            if(selectPlayerCategFrag != null)
                            {
                                fragmentTransaction = fragmentManager.beginTransaction();
                                fragmentTransaction.remove(selectPlayerCategFrag);
                                fragmentTransaction.commit();
                                selectPlayerCategFrag = null;
                            }

                            selectPlayerCategFrag = new SelectPlayCategoryFragment();
                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.fragment_container_new, selectPlayerCategFrag, "selectPlayerCateg");
                            fragmentTransaction.addToBackStack("selectPlayerCateg");
                            selectPlayerCategFrag.setArguments(args);

                            currentFrag = ScreenFrag.SELECTCATEGORYSCREEN;

                            fragmentTransaction.commit();

                        } else if (whichPlayer.equals("MultiPlayer")) {
                            fragmentManager = getFragmentManager();


                            if(clientListFrag != null)
                            {
                                fragmentTransaction = fragmentManager.beginTransaction();
                                fragmentTransaction.remove(clientListFrag);
                                fragmentTransaction.commit();
                                clientListFrag = null;
                            }

                            clientListFrag = new ClientListFragment();

                            Bundle args = new Bundle();
                            args.putString("userName", userName);
                            args.putString("connectedTVName", connectedTVName);
                            clientListFrag.setArguments(args);

                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.fragment_container_new, clientListFrag, "clientListFrag");
                            fragmentTransaction.addToBackStack("clientListScreen");
                            currentFrag = ScreenFrag.CLIENTLISTSCREEN;

                            fragmentTransaction.commit();
                        }
                    }
                } else if (responseStr != null) {
                    if (questionScreenFrag != null) {

                        if (progressSpinner != null) {
                            progressSpinner.setTitle("Sending answer");
                            progressSpinner.setMessage("Please wait ...");
                            progressSpinner.show();
                        }

                        // lock screen
                        questionScreenFrag.SetRadioGroupButton(false);
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
                        ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);
                    }

                } else if (questionStr != null) {

                    Log.v("test", questionStr);
                    // unlock screen

                    if (progressSpinner != null) {
                        progressSpinner.dismiss();
                    }

                    if (questionScreenFrag == null) {
                        questionScreenFrag = new QuestionScrenFragment();
                        fragmentTransaction = fragmentManager.beginTransaction();
                        questionScreenFrag.updateQuestionText(questionStr, option1Str, option2Str, option3Str, option4Str, questionNo);
                        questionScreenFrag.SetRadioGroupButton(true);

                        scoreScreenFrag = null;
                        fragmentTransaction.replace(R.id.fragment_container_new, questionScreenFrag);
                        currentFrag = ScreenFrag.QUESTIONSCREEN;

                        fragmentTransaction.addToBackStack("questionScreen");
                        //  fragmentTransaction.add(R.id.fragment_container_new, questionScreenFrag, "questionScreenFrag");

                        fragmentTransaction.commit();
                    } else {
                        questionScreenFrag.updateQuestionText(questionStr, option1Str, option2Str, option3Str, option4Str, questionNo);
                        questionScreenFrag.SetRadioGroupButton(true);
                        questionScreenFrag.resetSelectedAnswer();
                    }

                } else if (scoreStr != null) {

                    if (progressSpinner != null) {
                        progressSpinner.dismiss();
                    }

                    if (scoreScreenFrag == null) {
                        scoreScreenFrag = new ScoreScreenFragment();
                        fragmentTransaction = fragmentManager.beginTransaction();
                        scoreScreenFrag.updateScoreText(scoreStr);
                        questionScreenFrag = null;

                        fragmentTransaction.replace(R.id.fragment_container_new, scoreScreenFrag);
                        fragmentTransaction.addToBackStack("scoreScreen");

                        currentFrag = ScreenFrag.SCORESCREEN;

                        fragmentTransaction.commit();
                    } else {
                        scoreScreenFrag.updateScoreText(scoreStr);
                    }
                } else if (multiPlayer != null) {
                    if (multiPlayer.equals("yes")) {
                        Log.v("test", "multi player yes");
                    }
                    else if(multiPlayer.equals("no"))
                    {
                        if(waitScreenFrag != null)
                        {
                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.remove(waitScreenFrag);
                            fragmentTransaction.commit();
                            waitScreenFrag = null;
                        }

                        if(selectPlayerCategFrag != null)
                        {
                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.remove(selectPlayerCategFrag);
                            fragmentTransaction.commit();
                            selectPlayerCategFrag = null;
                        }
                        currentFrag = ScreenFrag.SELECTPLAYERSCREEN;

                        FragmentManager fm = getFragmentManager();
                        fm.popBackStack("selectPlayer", 0);
                    }
                } else if (playerType != null) {
                    if (playerType.equals("MultiPlayer")) {
                        if (multiPlayerFrag == null) {
                            multiPlayerFrag = new MultiPlayerScreenFragment();

                            Bundle args = new Bundle();
                            args.putString("clientName", clientName);
                            multiPlayerFrag.setArguments(args);

                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.replace(R.id.fragment_container_new, multiPlayerFrag);
                            fragmentTransaction.addToBackStack("multiPlayerScreenMsg");

                            currentFrag = ScreenFrag.MULTIPLAYERMSGSCREEN;
                            fragmentTransaction.commit();
                        }
                    }
                }
                else if(sessionEnd != null)
                {
                    if(sessionEnd.equals("end"))
                    {
                        fragmentManager = getFragmentManager();

                        if(multiPlayerFrag != null)
                        {
                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.remove(multiPlayerFrag);
                            fragmentTransaction.commit();
                            multiPlayerFrag = null;
                        }
                        if(questionScreenFrag != null)
                        {
                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.remove(questionScreenFrag);
                            fragmentTransaction.commit();
                            questionScreenFrag = null;
                        }

                        currentFrag = ScreenFrag.SELECTPLAYERSCREEN;
                        fragmentManager.popBackStack("selectPlayer", 0);
                    }
                }
                else if(changeCategory != null)
                {
                    if(changeCategory.equals("yes"))
                    {
                        if(multiPlayerFrag != null)
                        {
                            fragmentTransaction = fragmentManager.beginTransaction();
                            fragmentTransaction.remove(multiPlayerFrag);
                            fragmentTransaction.commit();
                            multiPlayerFrag = null;
                        }
                        currentFrag = ScreenFrag.SELECTPLAYERSCREEN;
                        fragmentManager.popBackStack("selectPlayer", 0);
                    }
                }
            }
        });

        application.setOnReadyListener(new Channel.OnReadyListener() {
            @Override
            public void onReady() {
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

                // spinner.setVisibility(View.GONE);
                if (progressSpinner != null)
                    progressSpinner.dismiss();

            }

            @Override
            public void onError(com.samsung.multiscreen.Error error) {
                Log.v(App.TAG, error.toString());
                Toast.makeText(ChoosePlayerActivity.this, "Please Re-start application!!!!", Toast.LENGTH_LONG).show();
            }
        });
    }

    public void launchCategoryFromMultiPlayer(String clientID)
    {
        fragmentManager = getFragmentManager();

        Bundle args = new Bundle();
        args.putString("selectPlayer", "MultiPlayer");
        args.putString("clientID", clientID);

        if(selectPlayerCategFrag != null)
        {
            fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.remove(selectPlayerCategFrag);
            fragmentTransaction.commit();
            selectPlayerCategFrag = null;
        }

        selectPlayerCategFrag = new SelectPlayCategoryFragment();
        fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.replace(R.id.fragment_container_new, selectPlayerCategFrag);
        fragmentTransaction.addToBackStack("selectPlayerCateg");
        selectPlayerCategFrag.setArguments(args);

        currentFrag = ScreenFrag.SELECTCATEGORYSCREEN;
        fragmentTransaction.commit();
    }

    public void launchWaitScreenFrag()
    {
        fragmentManager = getFragmentManager();


        if(waitScreenFrag != null)
        {
            fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.remove(waitScreenFrag);
            fragmentTransaction.commit();
            waitScreenFrag = null;
        }

        waitScreenFrag = new WaitScreenFragment();
        fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.replace(R.id.fragment_container_new, waitScreenFrag);
        fragmentTransaction.addToBackStack("waitScreen");
        currentFrag = ScreenFrag.WAITSCREEN;

        fragmentTransaction.commit();
    }

    @Override
    public void onBackPressed() {

     if(currentFrag == ScreenFrag.SELECTPLAYERSCREEN)
     {
         Log.v("test", "select player screen");
        finish();
     }
     else if(currentFrag == ScreenFrag.SELECTCATEGORYSCREEN || currentFrag == ScreenFrag.QUESTIONSCREEN ||
             currentFrag == ScreenFrag.SCORESCREEN)
     {
         fragmentManager = getFragmentManager();


         JSONObject jsonObj = null;
         try {
             jsonObj = new JSONObject();
             jsonObj.put("session", "end");
         } catch (Exception e) {
             e.printStackTrace();
         }

         String messageSend = jsonObj.toString();
         Log.v(App.TAG, messageSend);
         ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

         if(scoreScreenFrag != null)
         {
             fragmentTransaction = fragmentManager.beginTransaction();
             fragmentTransaction.remove(scoreScreenFrag);
             fragmentTransaction.commit();
             scoreScreenFrag = null;
         }


         if(waitScreenFrag != null)
         {
             fragmentTransaction = fragmentManager.beginTransaction();
             fragmentTransaction.remove(waitScreenFrag);
             fragmentTransaction.commit();
             waitScreenFrag = null;
         }

         if(selectPlayerCategFrag != null)
         {
             fragmentTransaction = fragmentManager.beginTransaction();
             fragmentTransaction.remove(selectPlayerCategFrag);
             fragmentTransaction.commit();
             selectPlayerCategFrag = null;
         }

         if(multiPlayerFrag != null)
         {
             fragmentTransaction = fragmentManager.beginTransaction();
             fragmentTransaction.remove(multiPlayerFrag);
             fragmentTransaction.commit();
             multiPlayerFrag = null;
         }
        /* if(clientListFrag != null)
         {
             fragmentTransaction = fragmentManager.beginTransaction();
             fragmentTransaction.remove(clientListFrag);
             fragmentTransaction.commit();
             clientListFrag = null;
         }*/


         if(questionScreenFrag != null)
         {
             fragmentTransaction = fragmentManager.beginTransaction();
             fragmentTransaction.remove(questionScreenFrag);
             fragmentTransaction.commit();
             questionScreenFrag = null;
         }

         currentFrag = ScreenFrag.SELECTPLAYERSCREEN;

         FragmentManager fm = getFragmentManager();
         fm.popBackStack("selectPlayer", 0);
        // fm.popBackStack("selectPlayerCateg", FragmentManager.POP_BACK_STACK_INCLUSIVE);
     }
     else if(currentFrag == ScreenFrag.CLIENTLISTSCREEN)
     {
         JSONObject jsonObj = null;
         try {
             jsonObj = new JSONObject();
             jsonObj.put("session", "end");
         } catch (Exception e) {
             e.printStackTrace();
         }

         String messageSend = jsonObj.toString();
         Log.v(App.TAG, messageSend);
         ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

         currentFrag = ScreenFrag.SELECTPLAYERSCREEN;

         FragmentManager fm = getFragmentManager();
         fm.popBackStack("clientListScreen", FragmentManager.POP_BACK_STACK_INCLUSIVE);
     }
     else if(currentFrag == ScreenFrag.MULTIPLAYERMSGSCREEN)
     {
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

         currentFrag = ScreenFrag.SELECTPLAYERSCREEN;
         FragmentManager fm = getFragmentManager();
         fm.popBackStackImmediate();
     }
     else if(currentFrag == ScreenFrag.WAITSCREEN)
     {

         JSONObject jsonObj = null;
         try {
             jsonObj = new JSONObject();
             jsonObj.put("changeCategory", "yes");
         } catch (Exception e) {
             e.printStackTrace();
         }

         String messageSend = jsonObj.toString();
         Log.v(App.TAG, messageSend);
         ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

         currentFrag = ScreenFrag.CLIENTLISTSCREEN;

         if(waitScreenFrag != null)
         {
             fragmentTransaction = fragmentManager.beginTransaction();
             fragmentTransaction.remove(waitScreenFrag);
             fragmentTransaction.commit();
             waitScreenFrag = null;
         }

         FragmentManager fm = getFragmentManager();
         fm.popBackStack("clientListScreen", /*FragmentManager.POP_BACK_STACK_INCLUSIVE*/0);
     }

    }

}
