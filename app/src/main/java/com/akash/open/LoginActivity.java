package com.akash.open;

import android.content.Intent;
import android.os.Bundle;
//import android.support.annotation.NonNull;
//import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class LoginActivity extends AppCompatActivity {
    private FirebaseAuth mAuth;
    private String user;
    private String pass;
    private ProgressBar progressBar;
    Button btn;
    TextView textViewCreateAccount;
    Button buttonGuestLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        final EditText userEdit=(EditText)findViewById(R.id.editTextEmail);
        final EditText userPass=(EditText)findViewById(R.id.editTextPassword);
        btn=(Button)findViewById(R.id.buttonLogin);
        textViewCreateAccount = (TextView) findViewById(R.id.textViewCreateAccount);
        buttonGuestLogin = (Button)findViewById(R.id.buttonGuestLogin);

        userEdit.setVisibility(View.GONE);
        userPass.setVisibility(View.GONE);
        btn.setVisibility(View.GONE);
        textViewCreateAccount.setVisibility(View.GONE);
        buttonGuestLogin.setVisibility(View.GONE);

        progressBar = (ProgressBar) findViewById(R.id.progressBar);
        progressBar.setVisibility(View.GONE);
     //   textViewCreateAccount.setText(fromHtml("<font color='#ffffff'>I don't have account yet. </font><font color='#00b8d4'>create one</font>"));
        textViewCreateAccount.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
              //  Intent intent = new Intent(LoginActivity.this, RegisterActivity.class);
               // startActivity(intent);
            }
        });

        mAuth = FirebaseAuth.getInstance();

        if(mAuth.getCurrentUser() == null){
            userEdit.setVisibility(View.VISIBLE);
            userPass.setVisibility(View.VISIBLE);
            btn.setVisibility(View.VISIBLE);
            textViewCreateAccount.setVisibility(View.VISIBLE);
            buttonGuestLogin.setVisibility(View.VISIBLE);
        }
        else{
            startActivity(new Intent(LoginActivity.this, DisplayScreenNav.class));
        }
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                progressBar.setVisibility(View.VISIBLE);
               String user= userEdit.getText().toString();
               String pass=userPass.getText().toString();
                ValidateLogin(user,pass);
                login(user,pass);
            }
        });

        buttonGuestLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext() , DisplayScreenNav.class));
            }
        });



    }

    @Override
    protected void onStart() {
        super.onStart();
        FirebaseUser currentUser = mAuth.getCurrentUser();

    }


    public void login(String email,String password){
        mAuth.signInWithEmailAndPassword(email, password)
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            // Sign in success, update UI with the signed-in user's information
                            Log.d("AUTH SUCCESS", "signInWithEmail:success");
                            FirebaseUser user = mAuth.getCurrentUser();
                            if(user!=null){
                                progressBar.setVisibility(View.GONE);
                                startActivity(new Intent(LoginActivity.this, DisplayScreenNav.class));
                            }
                        } else {
                            // If sign in fails, display a message to the user.
                            Log.w("AUTH FAILED", "signInWithEmail:failure", task.getException());

                            Toast.makeText(LoginActivity.this,"Invalid ID : "+ task.getResult(), Toast.LENGTH_LONG).show();
                        }

                        // ...
                    }
                });
    }
    public void ValidateLogin(String email,String password){
        if(email.equals(null)){
            Toast.makeText(this, "Please Enter Username", Toast.LENGTH_SHORT).show();
        }
        if(email.equals(null)){
            Toast.makeText(this, "Please Enter Password", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        this.finish();
    }
}
