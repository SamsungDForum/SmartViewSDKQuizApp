package com.samsung.msf2.quizapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends Activity
{
    private EditText userName=null;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        userName=(EditText)findViewById(R.id.edt_userName);
    }

    @Override
    protected void onResume()
    {
        super.onResume();

    }

    @Override
    public void onStop()
    {
        super.onStop();
    }


    @Override
    public void onPause()
    {
        super.onPause();
    }


    @Override
    public void onDestroy()
    {
        super.onDestroy();

    }

   public void onClick(View v)
   {
        switch (v.getId())
        {
            case R.id.btn_Play:
                userCheck();
                break;

            case  R.id.btn_About:

                Intent inn=new Intent(MainActivity.this,AboutActivity.class);
                startActivity(inn);

                break;

        }

    }

    public void userCheck()
    {
        String name=userName.getText().toString();
        if(name!=null && userName.getText().toString().length() >0)
        {
            App.str_deviceName=name;
            Intent in=new Intent(MainActivity.this,DeviceList.class);
            in.putExtra("userName", name);
            startActivity(in);
        }
        else
        {
            Toast.makeText(MainActivity.this,"Please enter name!!!!!",Toast.LENGTH_LONG).show();
        }
    }

}
