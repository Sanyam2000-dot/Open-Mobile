package com.akash.open;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.google.firebase.storage.StorageReference;

import java.util.ArrayList;
import java.util.List;

public class FlipperAdapter extends BaseAdapter {
    private Context mCtx;
    private List<StorageReference> heros;


    public FlipperAdapter(Context mCtx, List<StorageReference> heros){
        this.mCtx = mCtx;
        this.heros = heros;
        Log.i("IMAGE REF  ADAPTER   :", heros.get(0) + heros.get(0).getPath());


    }

    @Override
    public int getCount() {
        return heros.size();
    }

    @Override
    public Object getItem(int i) {
        return null;
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    @Override
    public View getView(int i, View convertView, ViewGroup viewGroup) {
        StorageReference hero = heros.get(i);
        Log.i("IMAGE REF  ADAPTER   :", hero.getName() + hero.getPath());

        LayoutInflater inflater = LayoutInflater.from(mCtx);
        View view = inflater.inflate(R.layout.flipper_items, null);
        ImageView imageView = (ImageView) view.findViewById(R.id.imageView);

        Glide.with(imageView.getContext()).load(hero).override(Target.SIZE_ORIGINAL,Target.SIZE_ORIGINAL).into(imageView);
        return view;
    }


}
