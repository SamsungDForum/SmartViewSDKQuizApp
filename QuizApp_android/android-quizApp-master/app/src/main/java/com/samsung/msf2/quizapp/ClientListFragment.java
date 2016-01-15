package com.samsung.msf2.quizapp;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;
import android.app.ListFragment;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import com.samsung.multiscreen.Message;

import org.json.JSONObject;

import java.util.ArrayList;


/**
 * A fragment representing a list of Items.
 * <p/>
 * <p/>
 * Activities containing this fragment MUST implement the {@link OnFragmentInteractionListener}
 * interface.
 */
public class ClientListFragment extends Fragment {

    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private ArrayList<String> clientList;
    private ArrayList<String> clientId;
    private ArrayList<String> cList;

    private ListView listViewClent;
    private CustomClientAdapter mListadapter;

    private String connectedTVName;
    private String userName;
    private Button btnRefresh = null;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.fragment_clientlist_screen, container, false);

        listViewClent = (ListView) v.findViewById(R.id.listViewClient);
        btnRefresh = (Button) v.findViewById(R.id.btnRefreshClientId);

        Bundle bundle = getArguments();
        userName = bundle.getString("userName");
        connectedTVName = bundle.getString("connectedTVName");

        clientList = new ArrayList<String>();
        clientId = new ArrayList<String>();
        cList = new ArrayList<>();
        mListadapter = new CustomClientAdapter(getActivity(), cList);
        listViewClent.setAdapter(mListadapter);

        getClientList();
        btnRefresh.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                getClientList();

            }
        });

    return v;
    }

    private void getClientList() {

                 clientList.clear();
                 clientId.clear();
                 cList.clear();
                 mListadapter.notifyDataSetChanged();

                 for (int i = 0; i < ChoosePlayerActivity.application.getClients().size(); i++) {
                     clientList.add("" + ChoosePlayerActivity.application.getClients().getChannel().getClients().list().get(i).getAttributes());
                 }

                 String[] arr = clientList.toArray(new String[clientList.size()]);


                 for (int i = 0; i < arr.length; i++) {
                     //String cName = arr[i].replaceAll("\\p{P}", "").replace("name=TV", "").replace("name=", "").replace("= ", "").replace("\\p{Alpha}", "");
                     String cName = arr[i].replace("name=TV", "").replace("name=", "").replace("= ", "").replace(", =", "").replace("\\p{Alpha}", "").replace("{", "").replace("}", "");

                     if (!cName.equalsIgnoreCase(userName) && !cName.equalsIgnoreCase(connectedTVName)) {
                         cList.add(cName);

                         clientId.add("" + ChoosePlayerActivity.application.getClients().getChannel().getClients().list().get(i).getId());
                     }
                 }


                 mListadapter.notifyDataSetChanged();

                 listViewClent.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                     @Override
                     public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {

                         String selectedId = clientId.get(position);

                         JSONObject jsonObj = null;
                         try {
                             jsonObj = new JSONObject();
                             jsonObj.put("clientID", selectedId);
                         } catch (Exception e) {
                             e.printStackTrace();
                         }

                         String messageSend = jsonObj.toString();
                         Log.v(App.TAG, messageSend);
                         ChoosePlayerActivity.application.publish("say", messageSend, Message.TARGET_HOST);

                         ((ChoosePlayerActivity) getActivity()).launchCategoryFromMultiPlayer(selectedId);

                     }
                 });

             }


             @Override
             public void onActivityCreated(Bundle savedInstanceState) {
                 super.onActivityCreated(savedInstanceState);
             }

  /*  @Override
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

    /*@Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

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
  /*  public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        public void onFragmentInteraction(String id);
    }
*/

         }
