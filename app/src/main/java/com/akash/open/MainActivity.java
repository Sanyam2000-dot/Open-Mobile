package com.akash.open;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.widget.Toast;


import com.akash.open.fragment.ForumFragment;
import com.akash.open.fragment.HomeFragment;
import com.akash.open.fragment.ProfileFragment;
import com.akash.open.fragment.SocialFragment;
import com.google.android.material.bottomnavigation.BottomNavigationView;

public class MainActivity extends AppCompatActivity {
    BottomNavigationView bottomNavigation;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        openFragment(HomeFragment.newInstance("", ""));


        bottomNavigation = findViewById(R.id.bottom);
        bottomNavigation.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                Log.i("h :", String.valueOf(item.getItemId()));
                switch (item.getItemId()) {
                    case R.id.home:
                        openFragment(HomeFragment.newInstance("", ""));
                        return true;
                    case R.id.forum:
                        openFragment(ForumFragment.newInstance("", ""));
                        return true;
                    case R.id.social:
                        openFragment(SocialFragment.newInstance("", ""));
                        return true;
                    case R.id.profile:
                        openFragment(ProfileFragment.newInstance("", ""));
                        return true;
                }
                return false;
            }
        });



    }
    public void openFragment(Fragment fragment) {
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.setCustomAnimations(android.R.anim.fade_in,android.R.anim.fade_out);
        transaction.replace(R.id.container, fragment);
        transaction.addToBackStack(null);
        transaction.commit();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        this.finish();
    }
}
