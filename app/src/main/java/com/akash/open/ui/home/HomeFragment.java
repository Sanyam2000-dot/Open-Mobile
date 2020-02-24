package com.akash.open.ui.home;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.media.Image;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterViewFlipper;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewFlipper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import com.akash.open.AdapterProgramGallary;
import com.akash.open.FlipperAdapter;
import com.akash.open.LoginActivity;
import com.akash.open.MainActivity;
import com.akash.open.R;
import com.akash.open.SliderAdapterExample;
import com.akash.open.SliderItem;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.ListResult;
import com.google.firebase.storage.StorageReference;
import com.smarteist.autoimageslider.IndicatorAnimations;
import com.smarteist.autoimageslider.SliderAnimations;
import com.smarteist.autoimageslider.SliderView;

import java.util.ArrayList;
import java.util.List;

import static com.firebase.ui.auth.AuthUI.getApplicationContext;

public class HomeFragment extends Fragment {

    private HomeViewModel homeViewModel;
    Button memberLogin;
    Button knowMore;
    FirebaseAuth mAuth;
    FirebaseStorage storage;
    List<StorageReference> imageRef;
    ImageView imgView;
    private AdapterViewFlipper adapterViewFlipper;

    private SliderAdapterExample adapter;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {


        mAuth = FirebaseAuth.getInstance();



        homeViewModel =
                ViewModelProviders.of(this).get(HomeViewModel.class);
        final View root = inflater.inflate(R.layout.nav_home_fragment, container, false);
        final TextView textView = root.findViewById(R.id.text_home);
        final TextView textView2 = root.findViewById(R.id.text_home2);
        knowMore = (Button)root.findViewById(R.id.buttonKnowMore);
        memberLogin = (Button)root.findViewById(R.id.buttonMemberLogin);
        adapterViewFlipper = (AdapterViewFlipper) root.findViewById(R.id.adapterViewFlipper);


        storage = FirebaseStorage.getInstance();


        imageRef = new ArrayList<StorageReference>();

        if(mAuth.getCurrentUser() == null){
            knowMore.setVisibility(View.GONE);
        }else {
            memberLogin.setVisibility(View.GONE);
        }
        knowMore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getContext(), MainActivity.class));
            }
        });

        memberLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(root.getContext() , LoginActivity.class));
            }
        });



        homeViewModel.getText().observe(getViewLifecycleOwner(), new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText("In Association with :");
                textView2.setText("AWARE | ADOPT | CONTRIBUTE");
            }
        });

        ImageView github = (ImageView) root.findViewById(R.id.github);
        ImageView insta = (ImageView) root.findViewById(R.id.InstaLogo);
        ImageView fb = (ImageView)root.findViewById(R.id.facebook);
        github.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String url = "https://github.com/upes-open";
                Intent i = new Intent(Intent.ACTION_VIEW);
                i.setData(Uri.parse(url));
                startActivity(i);
            }
        });

        fb.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(root.getContext(), "Work in Progress :)", Toast.LENGTH_SHORT).show();
            }
        });

        insta.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String url = "https://www.instagram.com/_o.p.e.n_/";
                Intent i = new Intent(Intent.ACTION_VIEW);
                i.setData(Uri.parse(url));
                startActivity(i);
            }
        });

        final StorageReference imagesRef = FirebaseStorage.getInstance().getReference().child("images/");


        imagesRef.listAll()
                .addOnSuccessListener(new OnSuccessListener<ListResult>() {
                    @Override
                    public void onSuccess(ListResult listResult) {
                        for (StorageReference prefix : listResult.getPrefixes()) {
                            // All the prefixes under listRef.
                            // You may call listAll() recursively on them.
                        }

                        for (StorageReference item : listResult.getItems()) {
                            // All the items under listRef.
                            imageRef.add(item);

                        }

                    }
                })
                .addOnCompleteListener(new OnCompleteListener<ListResult>() {
            @Override
            public void onComplete(@NonNull Task<ListResult> task) {
                FlipperAdapter adapter = new FlipperAdapter(root.getContext(), imageRef);
                Log.i("IMAGE REF" , imageRef +"  :  "  + adapter.getCount());

                adapterViewFlipper.post(new Runnable() {
                    @Override
                    public void run() {
                        adapterViewFlipper.setAdapter(new FlipperAdapter(root.getContext(), imageRef));
                    }
                });
                //adding it to adapterview flipper

                adapterViewFlipper.setFlipInterval(1500);
                adapterViewFlipper.startFlipping();
            }
        })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        // Uh-oh, an error occurred!
                    }
                });



        return root;
    }


}
