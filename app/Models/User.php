<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Fortify\TwoFactorAuthenticatable;
use Laravel\Jetstream\HasProfilePhoto;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens;
    use HasFactory;
    use HasProfilePhoto;
    use Notifiable;
    use TwoFactorAuthenticatable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'must_set_password',
        'email_verified_at',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_recovery_codes',
        'two_factor_secret',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'must_set_password' => 'boolean',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array<int, string>
     */
    protected $appends = [
        'profile_photo_url',
    ];

public function roles() {
    return $this->belongsToMany(\App\Models\Role::class)->withTimestamps();
}

/** Verifica se o usuário tem um ou mais roles (por name) */
public function hasRole($roles): bool
{
    $roles = is_array($roles) ? $roles : func_get_args();
    // garanta que os nomes passados estejam no mesmo formato salvo no banco
    $roles = array_map('strtolower', $roles);

    return $this->roles()
        ->whereIn('name', $roles)
        ->exists();
}

/** Atribui (anexa) um role pelo name ou pelo model */
public function assignRole($role): void
{
    $roleModel = $role instanceof \App\Models\Role
        ? $role
        : \App\Models\Role::where('name', strtolower($role))->firstOrFail();

    $this->roles()->syncWithoutDetaching([$roleModel->id]);
}

/** Remove um role pelo name ou pelo model */
public function removeRole($role): void
{
    $roleModel = $role instanceof \App\Models\Role
        ? $role
        : \App\Models\Role::where('name', strtolower($role))->first();

    if ($roleModel) {
        $this->roles()->detach($roleModel->id);
    }
}
}
