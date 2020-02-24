package com.akash.open;


import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.StringBufferInputStream;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

public class AdapterProgram extends RecyclerView.Adapter<AdapterProgram.ProgramViewHolder>{

    private  List<Post> postList;



    public AdapterProgram(List<Post> data ){
        this.postList = data;

    }


    @NonNull
    @Override
    public ProgramViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
        View view = inflater.inflate(R.layout.recycler_view_item,viewGroup,false);

        return new ProgramViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ProgramViewHolder programViewHolder, int i) {
        Post post = postList.get(i);

        programViewHolder.Heading.setText(post.title);
        programViewHolder.profileName.setText(post.author);
        programViewHolder.textPost.setText(post.description);

    }

    @Override
    public int getItemCount() {
        return postList.size();
    }

    public class ProgramViewHolder extends RecyclerView.ViewHolder {

       TextView Heading;
       TextView profileName;
       TextView textPost;

        public ProgramViewHolder(@NonNull View itemView) {
            super(itemView);

            Heading = (TextView) itemView.findViewById(R.id.Heading);
            profileName = (TextView)itemView.findViewById(R.id.profileName);
            textPost = (TextView)itemView.findViewById(R.id.textPost);
        }
    }
}
